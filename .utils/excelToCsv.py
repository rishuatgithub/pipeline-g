import pandas as pd
import os
import xlrd

'''
This sample util file converts an excel file to corresponding csv file.
'''

FILENAME=os.path.join(os.getcwd(),'data/superstore/superstore.xls')
OUTPUT_PATH=os.path.join(os.getcwd(),'data/')

wb = xlrd.open_workbook(FILENAME)

for sheet in wb.sheets(): 
    sheet_name=sheet.name
    print('Working on sheet: {}'.format(sheet_name))
    
    df = pd.read_excel(FILENAME, engine='xlrd', sheet_name=sheet_name)

    print('Creating the data output path. Directory: {}'.format(sheet_name.lower()))
    OUT_PATH=os.path.join(OUTPUT_PATH, '{}'.format(sheet_name.lower()))
    #print(OUT_PATH)
    os.mkdir(OUT_PATH)

    print('Generating the csv file without index')
    df.to_csv(os.path.join(OUT_PATH,'{}.csv'.format(sheet_name.lower())), index=False)