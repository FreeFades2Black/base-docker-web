from flask import Flask, render_template, request
import psycopg2

app = Flask(__name__)

@app.route('/')
def index():
    conn = psycopg2.connect(host='db', database='postgres', user='postgres', password='password')
    cur = conn.cursor()
    
    # 1. Update/Increment count
    cur.execute('UPDATE visitors SET count = count + 1 WHERE id = 1')
    
    # 2. Log this visit
    user_ip = request.remote_addr
    cur.execute('INSERT INTO visit_log (ip_address) VALUES (%s)', (user_ip,))
    
    # 3. Get current count and latest logs
    cur.execute('SELECT count FROM visitors WHERE id = 1')
    count = cur.fetchone()[0]
    
    cur.execute('SELECT ip_address, visit_time FROM visit_log ORDER BY visit_time DESC LIMIT 10')
    logs = cur.fetchall()
    
    conn.commit()
    cur.close()
    conn.close()
    
    return render_template('index.html', count=count, logs=logs)

if __name__ == '__main__':
    # Important: host='0.0.0.0' allows external access
    app.run(host='0.0.0.0', port=80)
