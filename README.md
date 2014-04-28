# HackathonCLT2014
<br>
Read about the challenge here: [Link to the Tresata github page](https://github.com/tresata/hackathonclt)
<br>
<br>
**Code/Product/Concept developed at the Hackathon Charlotte 2014.**
<br>
I decided to develop a app called "Express Lane Manager", the concept was developed for store clerks/express lane managers/store managers to essentially use iBeacon to recognize customers when arriving (i.e. in a drive up lane), and display details about that customer to provide a personalized shopping experience. The app displayed potential opportunities by doing a basic basket analysis of his current purchases on the express order list, by looking at when last certain products were purchased, and were not being purchased today (maybe they shoud be due for purchase) and hopefully encouraging the buyer to increase the basket size due to convienence.
<br><br>
- The app would also display coupon opportunities, similar products (once again, using a algorithm to consider purchase history, product category/UPC relevance) if something was out of stock, and some basic charting analysis to provide a better shopping experience.

<br><br>
## Architecture
### Hardware
---

Data center hardware/hosting was provided by Data Chambers, (5 Node Hadoop Cluster). In order to transfer data between the Hadoop slave and the iOS app I was running a SimpleHTTP Server (Port 8890 to avoid conflicts).
<br><br>
### Software
---

App was developed using iOS, a lot of the UI was mocked up in Photoshop to save on time constraints and simple used as a reference image in XCode. The Hadoop job was written in Scalding and included below. (Obviously lots of opportunity for improvement!).
<br><br>
### Data
---
This was the data set we were working from, it was around ~650 million rows.

Data Dictionary

    UPC_NUMBER                      long    unique product code of item
    MASTER_UPC_NUMBER               long    master UPC number, UPC numbers go under this  
    ITEM_DESCRIPTION                string  describes item
    DEPARTMENT_NUMBER               long    department number
    DEPARTMENT_DESCRIPTION          string  describes department
    CATEGORY_NUMBER                 long    category number of item
    CATEGORY_DESCRIPTION            string  describes category of item
    SUBCATEGORY_NUMBER              long    subcategory of item
    SUBCATEGORY_DESCRIPTION         string  describes subcategory of item
    RECEIPT_NUMBER                  string  recipe number of the purchase
    ITEM_QUANTITY                   long    how many items was bought
    EXTENDED_PRICE_AMOUNT           float   actual sale per swipe
    DISCOUNT_QUANTITY               float   number of coupons applied
    EXTENDED_DISCOUNT_AMOUNT        float   amount discounted
    TENDER_AMOUNT                   float   amount tendered by the customer for the transaction
    TRANSACTION_DATETIME            string  date of transaction
    EXPRESS_LANE                    long     flag of whether the purchase was through Express Lane, tagged to recipe number. 1 mean yes, 0 means no
    HHID                            string  house hold id 

<br><br>
##Screenshot
---

![App](http://www.li-labs.com/S2small.png)
