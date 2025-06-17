# %%

from pathlib import Path

import pandas as pd

# %%

filename = Path() / "transcript.txt"

with open(filename) as f:
    data = f.readlines()

data = [
    i.replace("\n", "").replace("#", "").split(";")
    for i in data
    if len(i.split(";")) == 5
]

data = pd.DataFrame(data[1:], columns=data[0])

data.columns = ["time", "result_o", "result_a_i", "result_b_i", "result_c_i"]

for c in data.columns:
    data[c] = data[c].astype(int).astype(str)

data.to_parquet(
    Path() / "time_and_component_results.parquet",
    index=False,
)

data.to_excel(
    Path() / "time_and_component_results.xlsx",
    index=False,
)

# %%
data = pd.read_parquet(
    Path() / "time_and_component_results.parquet",
)


# %%
error_value = "305419896"

for c in data.columns[1:]:
    data[f"{c}_is_error"] = (data[c].astype(str).str.contains(error_value)).astype(int)


# %%

data_sample = data.iloc[:5000, :]
error_analysis = pd.concat(
    [
        data_sample["result_o_is_error"].value_counts(normalize=True),
        data_sample["result_a_i_is_error"].value_counts(normalize=True),
        data_sample["result_b_i_is_error"].value_counts(normalize=True),
        data_sample["result_c_i_is_error"].value_counts(normalize=True),
    ],
    axis=1,
)

error_analysis.to_excel("error_analysis.xlsx")

error_analysis

# %%

tests = []

step = 100

for i in range(step, 5000 + step, step):
    data_sample = data.iloc[50000 : 50000 + i, :]

    temp = pd.concat(
        [
            data_sample["result_o_is_error"].value_counts(normalize=True),
            data_sample["result_a_i_is_error"].value_counts(normalize=True),
            data_sample["result_b_i_is_error"].value_counts(normalize=True),
            data_sample["result_c_i_is_error"].value_counts(normalize=True),
        ],
        axis=1,
    ).stack()

    temp.name = f"sample_{i}"

    tests.append(temp)


tests = pd.concat(tests, axis=1)

tests.T.tail().to_excel("cumulative_sample_error_analysis.xlsx")

# %%
