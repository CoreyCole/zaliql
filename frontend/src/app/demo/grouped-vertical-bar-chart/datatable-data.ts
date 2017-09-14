// schema data table
const schemaColumns = [
  { name: 'Carrier' },
  { name: 'Airport' },
  { name: 'Delay' },
  { name: 'Delayed' }
];
const schemaRows = [
  {
    carrier: 'AA',
    airport: 'COS',
    delay: '2',
    delayed: '0',
  },
  {
    carrier: 'UA',
    airport: 'MTJ',
    delay: '17',
    delayed: '1',
  },
  {
    carrier: 'AA',
    airport: 'COS',
    delay: '14',
    delayed: '0',
  },
  {
    carrier: 'AA',
    airport: 'MFE',
    delay: '15',
    delayed: '1',
  },
  {
    carrier: 'UA',
    airport: 'ROC',
    delay: '5',
    delayed: '0',
  },
  {
    carrier: 'UA',
    airport: 'MTJ',
    delay: '45',
    delayed: '1',
  },
];

// bias data table
const biasColumns = [
  { name: 'Rank' },
  { name: 'Carrier' },
  { name: 'Airport' },
  { name: 'Delayed' }
];
const biasRows = [
  {
    rank: '1',
    carrier: 'UA',
    airport: 'ROC',
    delayed: '1'
  },
  {
    rank: '2',
    carrier: 'AA',
    airport: 'MFE',
    delayed: '0'
  }
];

export { schemaColumns, schemaRows, biasColumns, biasRows };
