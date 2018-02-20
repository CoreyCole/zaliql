import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
# data to plot

def att():
    raw_data = {'first_name': ['EWR', 'IAH', 'JFK', 'LGA', 'SFO'],
                'Thunder': [0.137003427,
0.263518179,
0.00764084,
0.028428731,
8.40833E-12],
                'WindSpeed': [0.072219808,
0.018866153,
0.001928663,
0.015353816,
0.012587407],
                'LowVisibility': [0.103576355,
0.058249014,
0.093852093,
0.06375177,
0.019470698],
                'Snow': [0.08187676,
0.004285469,
0.044778897,
0.058227619,
0]}


    df = pd.DataFrame(raw_data, columns=['first_name', 'Thunder', 'WindSpeed', 'LowVisibility','Snow'])
    df
    pos = list(range(len(df['Thunder'])))
    width = 0.21
    # Plotting the bars
    fig, ax = plt.subplots(figsize=(10, 5))

    # Create a bar with pre_score data,
    # in position pos,
    plt.bar(pos,
            # using df['pre_score'] data,
            df['Thunder'],
            # of width
            width,
            # with alpha 0.5
            alpha=0.5,
            # with color
            color='#CD5C5C',
            # with label the first value in first_name
            label=df['first_name'][0])

    # Create a bar with mid_score data,
    # in position pos + some width buffer,
    plt.bar([p + width for p in pos],
            # using df['mid_score'] data,
            df['WindSpeed'],
            # of width
            width,
            # with alpha 0.5
            alpha=0.5,
            # with color
            color='#32CD32',
            # with label the second value in first_name
            label=df['first_name'][1])

    # Create a bar with post_score data,
    # in position pos + some width buffer,
    plt.bar([p + width * 2 for p in pos],
            # using df['post_score'] data,
            df['LowVisibility'],
            # of width
            width,
            # with alpha 0.5
            alpha=0.5,
            # with color
            color='#FFC222',
            # with label the third value in first_name
            label=df['first_name'][2])
    plt.bar([p + width * 3 for p in pos],
            # using df['post_score'] data,
            df['Snow'],
            # of width
            width,
            # with alpha 0.5
            alpha=0.5,
            # with color
            color='#800080',
            # with label the third value in first_name
            label=df['first_name'][3])

    # Set the y axis label
    ax.set_ylabel('Average Treatment Effect')
    ax.set_xlabel('Airports')

    # Set the chart's title

    # Set the position of the x ticks
    ax.set_xticks([p + 1.5 * width for p in pos])

    # Set the labels for the x ticks
    ax.set_xticklabels(df['first_name'])

    # Setting the x-axis and y-axis limits
    plt.xlim(min(pos) - width, max(pos) + width * 4)
    plt.ylim([0, max(df['Thunder'] + df['WindSpeed'] + df['LowVisibility']+df['Snow'])])

    # Adding the legend and showing the plot
    plt.legend(['Thunder', 'WindSpeed', 'LowVisibility','Snow'], loc='upper right')
    plt.grid()
    plt.rcParams.update({'font.size': 40})
    plt.savefig('/Users/babakmac/Documents/ZaliSQL/paper_vldb17_demo/camera-ready-paper/Figures/att.png')
    plt.show()
if __name__ == "__main__":
    att()