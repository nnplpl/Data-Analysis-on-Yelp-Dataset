# !/usr/bin/python

import pymysql
import matplotlib.pyplot as plt
from itertools import groupby
import numpy as np
import scipy.stats as stats
import pandas as pd
from sklearn.cluster import KMeans

def open_conn():
    """open the connection before each test case"""
    conn = pymysql.connect(user='root', password='111111',
                                   host='localhost',
                                   database='yelp_db')

    return conn

def close_conn(conn):
    """close the connection after each test case"""
    conn.close()
    
def executeQuery(conn, query, commit=False):
    """ fetch result after query"""
    cursor = conn.cursor()
    query_num = query.count(";")
    if query_num > 1:
        for result in cursor.execute(query, params=None, multi=True):
            if result.with_rows:
                result = result.fetchall()
    else:
        cursor.execute(query)
        result = cursor.fetchall()
    # we commit the results only if we want the updates to the database
    # to persist.
    if commit:
        conn.commit()
    else:
        conn.rollback()
    # close the cursor used to execute the query
    cursor.close()
    return result

def rating_basedOnTime():
    
    sql = "select date, stars from review where business_id='RESDUcs7fIiihp38-d6_6g' order by date;"
    result = executeQuery(conn, sql)
    result_list = [list(content) for key, content in groupby(result, key=lambda x:x[0])]
    date_list = [key for key, content in groupby(result, key=lambda x:x[0])]
    rating_list = []
    # Find all ratings
    for content in result_list:
        total = []
        for ele in content:
            total.append(ele[1])
        rating_list.append(total)
    # calculate avg rating until a particular day
    avg_rating, cnt = [0], 0
    for ratings in rating_list:
        sumUntilNow = cnt*avg_rating[-1] 
        cnt += len(ratings)
        sum_after = sum(ratings) + sumUntilNow
        avg_now = float(sum_after/cnt)
        avg_rating.append(avg_now)
    avg_rating = avg_rating[1:]
    # plot data
    x = date_list
    y = avg_rating
    fig = plt.figure()
    ax1 = fig.add_subplot(111)
    ax1.set_title('Rating_basedOnTime')
    plt.xlabel('Day after the first review')
    plt.ylabel('Average Rating until Now')
    ax1.set_ylim(ymin=0, ymax=5)
    ax1.plot(x, y)
    plt.savefig('Rating_in_time_sequence.png')
    plt.show()
    return 

def plot_numOfRate():
     
    sql = "select date, count(*) from review where business_id='RESDUcs7fIiihp38-d6_6g' group by date;"
    result = executeQuery(conn, sql)
    x_list = [item[0] for item in result]
    y_list = [item[1] for item in result]
    # plot data
    fig = plt.figure()
    ax1 = fig.add_subplot(111)
    ax1.set_title('NumOfRating_per_date')
    plt.xlabel('Date')
    plt.ylabel('Number')
    ax1.plot(x_list, y_list)
    plt.show()

if __name__ == '__main__':
    #open connection to the database
    conn = open_conn()
    rating_basedOnTime()
    plot_numOfRate()
    close_conn(conn)
