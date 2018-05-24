const simpleQueryAnswers = {
  'xAxis': 'Carrier',
  'yAxis': 'Average Delayed Flights',
  'data': [
    {
      'name': 'AA',
      'value': 0.11
    },
    {
      'name': 'UA',
      'value': 0.19
    }
  ]
};

const simpsonsParadox = {
  'xAxis': 'Airport',
  'yAxis': 'Average Delayed Flights',
  'data': [
    {
      'name': 'COS',
      'series': [
        {
          'name': 'AA',
          'value': 0.11
        },
        {
          'name': 'UA',
          'value': 0.08
        }
      ]
    },
    {
      'name': 'MFE',
      'series': [
        {
          'name': 'AA',
          'value': 0.09
        },
        {
          'name': 'UA',
          'value': 0.071
        }
      ]
    },
    {
      'name': 'MTJ',
      'series': [
        {
          'name': 'AA',
          'value': 0.17
        },
        {
          'name': 'UA',
          'value': 0.16
        }
      ]
    },
    {
      'name': 'ROC',
      'series': [
        {
          'name': 'AA',
          'value': 0.22
        },
        {
          'name': 'UA',
          'value': 0.21
        }
      ]
    }
  ]
};

const effectQuery1 = {
  'xAxis': 'Carrier',
  'yAxis': 'Average Delayed Flights',
  'data': [
    {
      'name': 'AA',
      'series': [
        {
          'name': 'Direct Effect',
          'value': 0.17
        },
        {
          'name': 'Total Effect',
          'value': 0.15
        },
        {
          'name': 'SQL Query',
          'value': 0.11
        }
      ]
    },
    {
      'name': 'UA',
      'series': [
        {
          'name': 'Direct Effect',
          'value': 0.17
        },
        {
          'name': 'Total Effect',
          'value': 0.14
        },
        {
          'name': 'SQL Query',
          'value': 0.18
        }
      ]
    }
  ]
};

const effectQuery2 = {
  'xAxis': 'Effect Type',
  'yAxis': 'Average Delayed Flights',
  'data': [
    {
      'name': 'Direct Effect',
      'series': [
        {
          'name': 'AA',
          'value': 0.17
        },
        {
          'name': 'UA',
          'value': 0.17
        }
      ]
    },
    {
      'name': 'Total Effect',
      'series': [
        {
          'name': 'AA',
          'value': 0.15
        },
        {
          'name': 'UA',
          'value': 0.14
        }
      ]
    },
    {
      'name': 'SQL Query',
      'series': [
        {
          'name': 'AA',
          'value': 0.11
        },
        {
          'name': 'UA',
          'value': 0.18
        }
      ]
    }
  ]
};

export { simpleQueryAnswers, simpsonsParadox, effectQuery1, effectQuery2 };
