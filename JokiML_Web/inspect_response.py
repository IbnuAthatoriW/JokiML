import json, urllib.request
for host in ['127.0.0.1:8000','192.168.1.5:8000']:
    url=f'http://{host}/api/auth/register'
    data=json.dumps({'name':'Test User','email':'testuser_mobile@example.com','password':'Password123!','password_confirmation':'Password123!'}).encode('utf-8')
    req=urllib.request.Request(url,data=data,headers={'Content-Type':'application/json'})
    print('HOST',host)
    try:
        with urllib.request.urlopen(req) as r:
            body=r.read().decode('utf-8',errors='replace')
            print('STATUS',r.status)
            print('HEADERS',r.getheaders())
            print('BODYSTART', body[:500])
    except Exception as e:
        print('ERROR',type(e).__name__,str(e))
        if hasattr(e,'read'):
            print('RESP', e.read().decode('utf-8',errors='replace')[:500])
