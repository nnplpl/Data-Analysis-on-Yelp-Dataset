# !/usr/bin/python

import pymysql
import matplotlib.pyplot as plt
from itertools import groupby
import numpy as np
import scipy.stats as stats
import pandas as pd
from sklearn.cluster import KMeans
from sklearn.linear_model import LinearRegression

def open_conn():
    """open the connection before each test case"""
    conn = pymysql.connect(user='root', password='Lanlan854&',
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

def length_and_useful():
    '''
    the relationship between evaluation length and the userful we get.
    '''
    # fetch results from the database, return type: tuple
    sql = "select text, useful from review limit 1000000;"
    result = executeQuery(conn, sql)
    # retreive results as a list from the list of tuples, list(group) ==>[(date1, rating1), (date1, rating2)]
    x_labels = np.array([len(text.split()) for text, useful in result])
    # get the length of text as x
    # y_labels = np.array([useful for text, useful in result])

    d = dict()
    for i in range(len(x_labels)):
        if x_labels[i] in d.keys():
            d[x_labels[i]] += 1
        else:
            d[x_labels[i]] = 1

    items = d.items()
    items.sort()
    x, y = [i[0] for i in items if i[0] <= 200 and i[0]>0], [i[1]/i[0] for i in items if i[0] <= 200 and i[0] >0 ]

    print(stats.pearsonr(x, y))

    fig = plt.figure()
    ax1 = fig.add_subplot(111)
    ax1.set_title('Text_length and Useful')
    plt.xlabel('Text_length')
    plt.ylabel('count(Useful)/count(text_length)')
    plt.plot(x, y)
    plt.show()
    return


if __name__ == '__main__':
    #open connection to the database
    conn = open_conn()

    length_and_useful()

    close_conn(conn)
