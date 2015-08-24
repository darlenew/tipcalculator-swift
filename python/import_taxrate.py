#!/usr/bin/env python
import os
import sqlite3
import csv

def taxrate_csv_reader(taxrate_csv_path):
    with open(taxrate_csv_path, 'rb') as fd:
        csv_reader = csv.reader(fd)
        next(csv_reader, None) # skip the headers
        for row in csv_reader:
            # data for louisiana didn't parse cleanly, so the taxrate index is -5
            zipcode, combinedrate = row[1], row[-5]
            try:
                int(zipcode)
            except:
                print taxrate_csv_path, row
            try:
                float(combinedrate)
            except:
                print taxrate_csv_path, row

            yield zipcode, combinedrate
    
if __name__ == "__main__":
    import argparse

    # process arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("path",
                        help="path to directory containing taxrate csv files")
    args = parser.parse_args()
    path = args.path

    # create database
    conn = sqlite3.connect('tipcalculator.sqlite3')
    c = conn.cursor()
    c.execute('drop table if exists taxrate')
    c.execute('create table taxrate(id integer primary key autoincrement, zip integer, taxrate real)')

    # process taxrate csv files
    for filename in os.listdir(path):
        csv_path = os.path.join(path, filename)
        for zipcode, combinedrate in taxrate_csv_reader(csv_path):
            vals = int(zipcode), float(combinedrate)
            sql = "insert into taxrate values(NULL, ?, ?)"
            c.execute(sql, vals)

    # save & close connection
    conn.commit()
    conn.close()


