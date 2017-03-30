#-*- coding:cp949-*-

import sys
import pymysql

def Run_InsertDB(arrLines, strDomain, strServerNM, strLogNum, Conn, Cur):

	listTemp = []
	arrLine = ""
	strTable = "TRAW00" + str(strLogNum)

	for arrLine in arrLines:
		if arrLine.count(" ") == 21:
			listLine = arrLine.split(" ")
			listTemp.append((strDomain, strServerNM, listLine[0], listLine[1], listLine[5], listLine[6], listLine[7], listLine[10], listLine[16], listLine[19], listLine[20], listLine[21]))

	strSQL = ""
	strSQL = strSQL + "INSERT INTO " + strTable + " "
	strSQL = strSQL + "VALUES"
	strSQL = strSQL + "(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
		
	try:
		strError = Cur.executemany(strSQL, listTemp)
		Conn.commit()
		
	except Exception as e:
                Conn.rollback()
                print ('error : {0}', e)

strPath = sys.argv[1]
strDomain = sys.argv[2]
strServerNM = sys.argv[3]
strLogNum = sys.argv[4]

Conn = pymysql.connect(host='192.168.101.64', port=13306, user='root', passwd='rnjswnstkd!2', db='IISLog', charset='UTF8')
Cur = Conn.cursor()

with open(strPath, mode="rt", errors="ignore") as f:
	while True:
		arrlines = f.readlines(1000000)

		if not arrlines: break

		Run_InsertDB(arrlines, strDomain, strServerNM, strLogNum, Conn, Cur)

Conn.close()
