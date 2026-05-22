from flask import Flask, render_template, request
import psycopg2

app = Flask(__name__)

def get_db():
    return psycopg2.connect(host='db', database='postgres', user='postgres', password='password')

@app.route('/')
def index():
    # Capture the actual public IP provided by the Cloudflare edge layer
    user_ip = request.headers.get('CF-Connecting-IP', request.remote_addr)
    ref = request.args.get('ref', 'Direct')

    conn = get_db()
    cur = conn.cursor()

    try:
        # 1. Update the global historical counter
        cur.execute('UPDATE visitors SET count = count + 1 WHERE id = 1')
        cur.execute('SELECT count FROM visitors WHERE id = 1')
        total_count = cur.fetchone()[0]

        # 2. Insert or update the unique profile to ensure an ID exists
        # RETURNING id guarantees we grab the key whether it is new or existing
        cur.execute('''
            INSERT INTO user_profiles (ip_address) 
            VALUES (%s) 
            ON CONFLICT (ip_address) 
            DO UPDATE SET ip_address = EXCLUDED.ip_address
            RETURNING id;
        ''', (user_ip,))
        profile_id = cur.fetchone()[0]

        # 3. Log this specific event entry linked via the Foreign Key relation
        cur.execute('''
            INSERT INTO visit_log (profile_id, referrer) 
            VALUES (%s, %s);
        ''', (profile_id, ref))

        conn.commit()

    except Exception as e:
        conn.rollback()
        print(f"Transaction failed: {e}")
        total_count = "Unavailable"
        
    finally:
        cur.close()
        conn.close()

    return f'''
    <h1>Application Control Center</h1>
    <p><strong>Total Metrics Count:</strong> {total_count}</p>
    <hr>
    <p>Logged Connection: {user_ip} (Profile ID: {profile_id})</p>
    '''

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
