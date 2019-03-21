
import pymysql
# start
# imports

users = ["user1","user2","user3","user4","user5"] # users created in mysql. This users has different permissions to execute different tasks in mysql
passwords=["","123","345","567","789"] # passwords created in mysql associated with a user.
type_user = ""

def Menu():

    type_user = input("WRITE THE NUMBER OF TYPE OF USER DEPENDING OF WHAT DO YOU WANT TO EXECUTE:\n 1:Casual User(Allows to view data) \n 2:User_of_yelp(Insert a review) \n 3:Data Analyst User(Allows to read all the relations with all attributes) \n 4:User developer(Allows to modify,read,insert.delete data) \n 5:User root with all permises ")
    if type_user=="1":
        casualuser()
    if type_user == "2":
        yelpuser()
    if type_user == "3":
        datanalystuser()
    if type_user == "4":
        developeruser()
    if type_user == "5":
        rootuser()

def casualuser():
    # This part simulate a request for a web server which request information to the database
    #In this example the web server is asking information about the user Monera to the database
    # open connection to the database
    conn = pymysql.connect(host='localhost',
                           port=3306,
                           user=users[0],
                           passwd=passwords[0],
                           db='yelp_db',
                           charset='utf8')
    user='Monera'  #This variable simulate the request of the web server. The casual user only has permission to enter to some views. In this case is entering to the view user_business_tip
    cur = conn.cursor()
    cur.execute("SELECT * FROM USER_BUSINESS_TIP WHERE Username=%s;",user)

    print("\n \n")
    print("Result")
    print(cur.fetchall())  #This print simulate the information which is retrieved for the database and presented to the user in the web
     # close connection to the database
    cur.close()
    conn.close()

def yelpuser(): # This simulate like a user who has an account in YELP. First the user should authenticate in the web
    login = input("ENTER USERNAME: ")
    password = input("ENTER PASSWORD: ")
    if login==users[1] and password==passwords[1]:
        review_by_user = input("WRITE A REVIEW ")  #The user which is authenticated can insert a review only in his user
        print("\nLOGIN SUCCESFUL\n")
        # open connection to the database
        conn = pymysql.connect(host='localhost',
                               port=3306,
                               user=users[1],
                               passwd=passwords[1],
                               db='yelp_db',charset='utf8')
        cur = conn.cursor()
        id1='123554564'
        businessid='--6MefnULPED_I942VcFNA'
        userid=users[1]   #This variable guarantees that the user with the login only can enter a review in his account
        stars1='5'
        date1='2018-02-17 00:00:00'
        text1=review_by_user
        useful1=1
        funny1=1
        cool1=1
        cur.execute("INSERT INTO review(id, business_id, user_id, stars, date, text, useful, funny, cool)"
                    " VALUES(%s, %s, %s, %s, %s,%s,%s,%s,%s);",
                    (id1,businessid,userid,stars1,date1,text1,useful1,funny1,cool1))
        print(cur.fetchall())
        conn.commit()
        # close connection to the database
        print("\n \n")
        print("Insertion successful")
        cur.close()
        conn.close()
    else: print("\nFAILED AUTHENTICATION\n")


def datanalystuser():  #This kind of user can see all the relations in the database and create views. It should have enter to the database with a log in and password
    login = input("ENTER USERNAME: ")
    password = input("ENTER PASSWORD: ")

    if login == users[2] and password ==passwords [2]:
        print("\nLOGIN SUCCESFUL\n")
        # open connection to the database
        conn = pymysql.connect(host='localhost',
                               port=3306,
                               user=users[2],
                               passwd=passwords [2],
                               db='yelp_db',
                               charset='utf8')
        cur = conn.cursor()
        cur.execute("SELECT * FROM USER WHERE ID='---94vtJ_5o_nikEs6hUjg';") # In this case the user wants to know all the information of an ID
        print("\n \n")
        print("Result")
        print(cur.fetchall())

        # close connection to the database
        cur.close()
        conn.close()
    else:
        print("\nFAILED AUTHENTICATION\n")

def  developeruser(): #This kind of user can execute tasks as insert,delete,alter information, create tables, create indexes. This user should enter to the database with a user and password
    login = input("ENTER USERNAME: ")
    password = input("ENTER PASSWORD: ")

    if login == users[3] and password ==passwords [3]:
        print("\nLOGIN SUCCESFUL\n")
        # open connection to the database
        conn = pymysql.connect(host='localhost',
                               port=3306,
                               user=users[3],
                               passwd=passwords [3],
                               db='yelp_db',
                               charset='utf8')

        cur = conn.cursor()
        cur.execute("SELECT * FROM USER_BUSINESS_TIP WHERE Username='Monera';")
        print("\n \n")
        print("Result")
        print(cur.fetchall())
        # close connection to the database
        cur.close()
        conn.close()
    else:
        print("\nFAILED AUTHENTICATION\n")

def rootuser(): #This kind of user has all the permissions in the database. It includes to create users and give permissions.
    login = input("ENTER USERNAME: ")
    password = input("ENTER PASSWORD: ")

    if login == users[4] and password ==passwords [4]:
        print("\nLOGIN SUCCESFUL\n")
        # open connection to the database
        conn = pymysql.connect(host='localhost',
                               port=3306,
                               user=users[4],
                               passwd=passwords[4],
                               db='yelp_db',
                               charset='utf8')
        cur = conn.cursor()
        cur.execute("SELECT * FROM USER_BUSINESS_TIP WHERE Username='Monera';")
        print("\n \n")
        print("Result")
        print(cur.fetchall())
        # close connection to the database
        cur.close()
        conn.close()
    else: print("\nFAILED AUTHENTICATION\n")


while type_user != "q":
    Menu()

# end