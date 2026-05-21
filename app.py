from flask import Flask, render_template, request
import psycopg2

app = Flask(__name__)

def get_db():
    return psycopg2.connect(host='db', database='postgres', user='postgres', password='password')

@app.route('/')
def index():
    user_ip = request.remote_addr
    ref = request.args.get('ref', 'Direct Entry')

    conn = get_db()
    cur = conn.cursor()
    
    try:
        # 1. Increment total historical hits
        cur.execute('UPDATE visitors SET count = count + 1 WHERE id = 1')
        cur.execute('SELECT count FROM visitors WHERE id = 1')
        total_count = cur.fetchone()[0]
        
        # 2. Insert or update user profile to capture their internal ID
        cur.execute('''
            INSERT INTO user_profiles (ip_address) 
            VALUES (%s) 
            ON CONFLICT (ip_address) DO UPDATE SET ip_address = EXCLUDED.ip_address
            RETURNING id;
        ''', (user_ip,))
        profile_id = cur.fetchone()[0]
        
        # 3. Log the visit using the generated foreign key
        cur.execute('''
            INSERT INTO visit_log (profile_id, referrer) 
            VALUES (%s, %s);
        ''', (profile_id, ref))
        
        # 4. Pull recent stream data via a SQL JOIN
        cur.execute('''
            SELECT p.ip_address, p.nickname, l.referrer, l.visit_time 
            FROM visit_log l
            JOIN user_profiles p ON l.profile_id = p.id
            ORDER BY l.visit_time DESC 
            LIMIT 5;
        ''')
        recent_visitors = cur.fetchall()
        
        conn.commit()
    except Exception as e:
        conn.rollback()
        return f"Database Error: {str(e)}"
    finally:
        cur.close()
        conn.close()
        
    return render_template('index.html', count=total_count, logs=recent_visitors)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
