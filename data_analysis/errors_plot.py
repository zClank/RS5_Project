# %%
import pandas as pd
import matplotlib.pyplot as plt

# %%

data = pd.read_parquet("time_and_component_results.parquet")

data.head()

# %%

time = data['time'].astype(int).values
result   = (data['result_o'] == '305419896').astype(int).values
result_a = (data['result_a_i'] == '305419896').astype(int).values
result_b = (data['result_b_i'] == '305419896').astype(int).values
result_c = (data['result_c_i'] == '305419896').astype(int).values

y = [result, result_a, result_b, result_c]
for v in y:
    for ix, val in enumerate(v):
        v[ix] = None if not v[ix] else v[ix]

# %%
n = 750

space = .2

plt.figure(figsize=(15,4))
plt.scatter(time[:n], result_a[:n]*1*space, color='green')
plt.scatter(time[:n], result_b[:n]*2*space, color='blue')
plt.scatter(time[:n], result_c[:n]*3*space, color='red')
plt.scatter(time[:n],   result[:n]*4*space, color='magenta')

plt.title('Errors')

plt.legend(
    ['error_execute_a', 'error_execute_b', 'error_execute_c', 'arbiter'],
    loc='lower right'
)
# plt.vlines()

plt.savefig('errors_plot.jpg')
plt.show()

# %%
