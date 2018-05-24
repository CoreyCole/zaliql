//tslint:disable
const resultDataExample = {
  "function_name": "matchit_cem_summary_statistics",
  "params": {
    "original_table": "flights_weather_demo",
    "matchit_cem_table": "flights_weather_demo_matched",
    "treatment": "lowpressure",
    "outcome": "depdel15",
    "grouping_attribute": "airport",
    "original_covariates_arr": [
      "vism",
      "wspdm",
      "hum",
      "thunder",
      "fog",
      "hail"
    ],
    "original_ordinal_covariates_arr": [
      "vism",
      "wspdm"
    ],
    "binned_ordinal_covariates_arr": [
      "vism_ew_binned_10",
      "wspdm_ew_binned_9"
    ]
  },
  "status": {
    "qq": {
      "vism": {
        "matchedData": {
          "0.1": {
            "control": 7,
            "treated": 6
          },
          "0.2": {
            "control": 7,
            "treated": 7
          },
          "0.3": {
            "control": 7,
            "treated": 7
          },
          "0.4": {
            "control": 7,
            "treated": 7
          },
          "0.5": {
            "control": 7,
            "treated": 7
          },
          "0.6": {
            "control": 7,
            "treated": 7
          },
          "0.7": {
            "control": 7,
            "treated": 7
          },
          "0.8": {
            "control": 7,
            "treated": 7
          },
          "0.9": {
            "control": 7,
            "treated": 7
          }
        },
        "originalData": {
          "0.1": {
            'control': 12.9,
            'treated': 6.4
          },
          '0.2': {
            'control': 16.1,
            'treated': 12.9
          },
          '0.3': {
            'control': 16.1,
            'treated': 16.1
          },
          '0.4': {
            'control': 16.1,
            'treated': 16.1
          },
          '0.5': {
            'control': 16.1,
            'treated': 16.1
          },
          '0.6': {
            'control': 16.1,
            'treated': 16.1
          },
          '0.7': {
            'control': 16.1,
            'treated': 16.1
          },
          '0.8': {
            'control': 16.1,
            'treated': 16.1
          },
          '0.9': {
            'control': 16.1,
            'treated': 16.1
          }
        }
      },
      'wspdm': {
        'matchedData': {
          '0.1': {
            'control': 1,
            'treated': 1
          },
          '0.2': {
            'control': 1,
            'treated': 2
          },
          '0.3': {
            'control': 2,
            'treated': 2
          },
          '0.4': {
            'control': 2,
            'treated': 3
          },
          '0.5': {
            'control': 2,
            'treated': 3
          },
          '0.6': {
            'control': 2,
            'treated': 3
          },
          '0.7': {
            'control': 3,
            'treated': 4
          },
          '0.8': {
            'control': 3,
            'treated': 4
          },
          '0.9': {
            'control': 4,
            'treated': 4
          }
        },
        'originalData': {
          '0.1': {
            'control': 5.6,
            'treated': 9.3
          },
          '0.2': {
            'control': 7.4,
            'treated': 13
          },
          '0.3': {
            'control': 9.3,
            'treated': 14.8
          },
          '0.4': {
            'control': 11.1,
            'treated': 18.5
          },
          '0.5': {
            'control': 13,
            'treated': 22.2
          },
          '0.6': {
            'control': 14.8,
            'treated': 24.1
          },
          '0.7': {
            'control': 16.7,
            'treated': 27.8
          },
          '0.8': {
            'control': 20.4,
            'treated': 31.5
          },
          '0.9': {
            'control': 24.1,
            'treated': 37
          }
        }
      }
    },
    'ate': {
      'matchedData': {
        'treatment': [
          {
            'treatment': 0,
            'grouping_attribute': 'MFE',
            'weighted_avg_outcome': 0.0568433117583603
          },
          {
            'treatment': 1,
            'grouping_attribute': 'MFE',
            'weighted_avg_outcome': 0.09798318291441269
          }
        ],
        'covariates': {
          'vism': [
            {
              'treatment': 0,
              'grouping_attribute': 'MFE',
              'weighted_avg_outcome': 0.0568433117583603
            },
            {
              'treatment': 1,
              'grouping_attribute': 'MFE',
              'weighted_avg_outcome': 0.09798318291441269
            }
          ],
          'wspdm': [
            {
              'treatment': 0,
              'grouping_attribute': 'MFE',
              'weighted_avg_outcome': 0.0568433117583603
            },
            {
              'treatment': 1,
              'grouping_attribute': 'MFE',
              'weighted_avg_outcome': 0.09798318291441269
            }
          ]
        }
      },
      'originalData': {
        'avgOutcomeDiff': 0.06187838554176951,
        'avgOutcomeControl': 0.1964622641509434,
        'avgOutcomeTreated': 0.2583406496927129
      }
    },
    'allData': {
      'dataSizes': {
        'totalDataSize': 25239,
        'controlDataSize': 4315,
        'treatedDataSize': 4719
      },
      'covariateStats': {
        'fog': {
          'meanDiff': 0.0016095776129485177,
          'meanControl': 0.0034762456546929316,
          'meanTreated': 0.0050858232676414495,
          'meanControlStdDev': 0.05885712676338491,
          'meanTreatedStdDev': 0.07113337943140173
        },
        'hum': {
          'meanDiff': -3.0236341784443788,
          'meanControl': 55.53922934076137,
          'meanTreated': 52.515595162317,
          'meanControlStdDev': 19.71305513529734,
          'meanTreatedStdDev': 27.26662681337145
        },
        'hail': {
          'meanDiff': 0,
          'meanControl': 0,
          'meanTreated': 0,
          'meanControlStdDev': 0,
          'meanTreatedStdDev': 0
        },
        'vism': {
          'meanDiff': -0.9005028941112784,
          'meanControl': 15.038199118124854,
          'meanTreated': 14.137696224013576,
          'meanControlStdDev': 3.1217104264079465,
          'meanTreatedStdDev': 4.14743535981585
        },
        'wspdm': {
          'meanDiff': 8.467478455393344,
          'meanControl': 13.647852333410727,
          'meanTreated': 22.115330788804073,
          'meanControlStdDev': 8.15035809278654,
          'meanTreatedStdDev': 11.164248357485162
        },
        'thunder': {
          'meanDiff': 0.003755681096879875,
          'meanControl': 0.008111239860950173,
          'meanTreated': 0.01186692095783005,
          'meanControlStdDev': 0.08969641937596119,
          'meanTreatedStdDev': 0.10828710516405295
        }
      }
    },
    'matchedData': {
      'dataSizes': {
        'totalDataSize': 7416,
        'controlDataSize': 3956,
        'treatedDataSize': 3460
      },
      'covariateStats': {
        'vism_ew_binned_10': {
          'meanDiff': -0.1986963535304535,
          'meanControl': 6.757077856420627,
          'meanTreated': 6.558381502890174,
          'meanControlStdDev': 1.0254042853615701,
          'meanTreatedStdDev': 1.3985135519663654
        },
        'wspdm_ew_binned_9': {
          'meanDiff': 0.7167302758084595,
          'meanControl': 2.2578361981799797,
          'meanTreated': 2.9745664739884394,
          'meanControlStdDev': 1.0021472242711462,
          'meanTreatedStdDev': 1.1391308229120904
        }
      }
    }
  }
};
