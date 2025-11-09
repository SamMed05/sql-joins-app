export const DEFAULT_VALUE = '0.0.0'

export const SQL_MAP = {
  [DEFAULT_VALUE]: {
    sql: '',
    description: 'No Join: Select how you want to join tables A and B.'
  },
  '1.0.0': {
    sql: `
SELECT *
FROM A
LEFT JOIN B ON A.key = B.key
WHERE B.key IS NULL
    `,
    description:
      'Left Anti Join: Returns rows that exist in A but not in B. Use a LEFT OUTER JOIN and filter with WHERE B.key IS NULL.'
  },
  '1.1.0': {
    sql: `
SELECT *
FROM A
LEFT JOIN B ON A.key = B.key
    `,
    description:
      'Left Outer Join: Returns all rows from A with matching rows from B when available. Non-matching B columns are NULL.'
  },
  '1.1.1': {
    sql: `
SELECT *
FROM A
FULL OUTER JOIN B ON A.key = B.key
    `,
    description:
      'Full Outer Join: Returns all rows from both A and B, combining matches. Non-matching columns are set to NULL.'
  },
  '0.1.0': {
    sql: `
SELECT *
FROM A
INNER JOIN B ON A.key = B.key
    `,
    description:
      'Inner Join: Returns only rows with matching keys in both A and B.'
  },
  '0.1.1': {
    sql: `
SELECT *
FROM A
RIGHT JOIN B ON A.key = B.key
    `,
    description:
      'Right Outer Join: Returns all rows from B with matching rows from A when available. Non-matching A columns are NULL.'
  },
  '0.0.1': {
    sql: `
SELECT *
FROM A
RIGHT JOIN B ON A.key = B.key
WHERE A.key IS NULL
    `,
    description:
      'Right Anti Join: Returns rows that exist in B but not in A. Use a RIGHT OUTER JOIN and filter with WHERE A.key IS NULL.'
  },
  '1.0.1': {
    sql: `
SELECT *
FROM A
FULL OUTER JOIN B ON A.key = B.key
WHERE A.key IS NULL OR B.key IS NULL
    `,
    description:
      'Full Anti Join: Returns rows unique to A or B (non-matching on key) using a FULL OUTER JOIN and filtering WHERE A.key IS NULL OR B.key IS NULL.'
  }
}
