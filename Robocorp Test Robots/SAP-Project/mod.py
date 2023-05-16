import pyodbc
def connect_to_server(driver,server,db,user,passw):
        driver_s=driver
        server_s=server
        db_s=db
        user_s=user
        password_s=passw
        connection_string = 'DRIVER={'+driver_s+'};SERVER='+server_s+';DATABASE='+db_s+';UID='+user_s+';PWD='+password_s+''
        connection = pyodbc.connect(connection_string)
        return  connection
def gettingdata(connection,sql_query):
        cursor = connection.cursor()
        cursor.execute(sql_query)
        columns = [column[0] for column in cursor.description]
        count = len(columns)
        results = cursor.fetchall()
        my_list = []
        for row in results:
             for colu in range(count):
                  data=columns[colu] + ": " + str(row[colu])
                  my_list.append(data)
        return  my_list
        connection.close()
def gettingdataparameter(connection,sql_query,parameter):
        cursor = connection.cursor()
        cursor.execute(sql_query,parameter)
        columns = [column[0] for column in cursor.description]
        count = len(columns)
        results = cursor.fetchall()
        my_list = []
        for row in results:
             for colu in range(count):
                  data=columns[colu] + ": " + str(row[colu])
                  my_list.append(data)
        return  my_list
        connection.close()
