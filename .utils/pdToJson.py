import os
import pandas as pd

df = pd.read_csv(os.path.join(os.getcwd(),'data/people/people.csv'))

print(df)

result = df.to_json(orient='records')

print(result)