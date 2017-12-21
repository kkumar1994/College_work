from collections import Counter, defaultdict
from itertools import chain, combinations
import glob
import matplotlib.pyplot as plt
import numpy as np
import os
import re
from scipy.sparse import csr_matrix
from sklearn.cross_validation import KFold
from sklearn.linear_model import LogisticRegression
import string
import tarfile
import urllib.request
from collections import Counter, defaultdict
from itertools import chain, combinations
import glob
import matplotlib.pyplot as plt
import numpy as np
import os
import re
from scipy.sparse import csr_matrix
from sklearn.cross_validation import KFold
from sklearn.linear_model import LogisticRegression
import string
import tarfile
import urllib.request
docs = [["hello", "world", "hello"], ["goodbye", "cruel", "world"]]
indptr = [0]
indices = []
data = []
vocabulary = {}
for d in docs:
    for term in d:
            index = vocabulary.setdefault(term, len(vocabulary))
            indices.append(index)
            data.append(1)
            print(data)
            indptr.append(len(indices))
            print(indptr)
            print(vocabulary)
print(csr_matrix((data, indices, indptr), dtype=int).toarray())
