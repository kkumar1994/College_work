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


def download_data():
    """ Download and unzip data.
    DONE ALREADY.
    """
    url = 'https://www.dropbox.com/s/xk4glpk61q3qrg2/imdb.tgz?dl=1'
    urllib.request.urlretrieve(url, 'imdb.tgz')
    tar = tarfile.open("imdb.tgz")
    tar.extractall()
    tar.close()


def read_data(path):
    """
    Walks all subdirectories of this path and reads all
    the text files and labels.
    DONE ALREADY.

    Params:
      path....path to files
    Returns:
      docs.....list of strings, one per document
      labels...list of ints, 1=positive, 0=negative label.
               Inferred from file path (i.e., if it contains
               'pos', it is 1, else 0)
    """
    fnames = sorted([f for f in glob.glob(os.path.join(path, 'pos', '*.txt'))])
    data = [(1, open(f).readlines()[0]) for f in sorted(fnames)]
    fnames = sorted([f for f in glob.glob(os.path.join(path, 'neg', '*.txt'))])
    data += [(0, open(f).readlines()[0]) for f in sorted(fnames)]
    data = sorted(data, key=lambda x: x[1])
    return np.array([d[1] for d in data]), np.array([d[0] for d in data])

def tokenize(doc, keep_internal_punct=False):
    """
    Tokenize a string.
    The string should be converted to lowercase.
    If keep_internal_punct is False, then return only the alphanumerics (letters, numbers and underscore).
    If keep_internal_punct is True, then also retain punctuation that
    is inside of a word. E.g., in the example below, the token "isn't"
    is maintained when keep_internal_punct=True; otherwise, it is
    split into "isn" and "t" tokens.

    Params:
      doc....a string.
      keep_internal_punct...see above
    Returns:
      a numpy array containing the resulting tokens.

    >>> tokenize(" Hi there! Isn't this fun?", keep_internal_punct=False)
    array(['hi', 'there', 'isn', 't', 'this', 'fun'], 
          dtype='<U5')
    >>> tokenize("Hi there! Isn't this fun? ", keep_internal_punct=True)
    array(['hi', 'there', "isn't", 'this', 'fun'], 
          dtype='<U5')
    """
    #TODO
    if(keep_internal_punct is False):
        text = re.compile("[\W]_")
        print(text)
        return np.array(re.sub(text,' ', doc.lower()).split())
        print(np.array)
    
    elif(keep_internal_punct is True):
        text = re.compile("[\^!@#$%&*?]+")
        return np.array(re.sub(text,' ', doc.lower()).split())
        print(np.array)
    else:
        pass
    feats=defaultdict(lambda:0)
def token_features(tokens, feats):
    """
    Add features for each token. The feature name
    is pre-pended with the string "token=".
    Note that the feats dict is modified in place,
    so there is no return value.

    Params:
      tokens...array of token strings from a document.
      feats....dict from feature name to frequency
    Returns:
      nothing; feats is modified in place.

    >>> feats = defaultdict(lambda: 0)
    >>> token_features(['hi', 'there', 'hi'], feats)
    >>> sorted(feats.items())
    [('token=hi', 2), ('token=there', 1)]
    """    
    #TODO
    
    #feats= defaultdict(lambda: 0)
    print(tokens)
    for i in tokens:
        if(not feats["token="+i]):
            feats["token="+i] = 1
        elif(feats["token="+i]):
            feats["token="+i] += 1
        else:
            pass
def token_pair_features(tokens, feats, k=3):
    """
    Compute features indicating that two words occur near
    each other within a window of size k.

    For example [a, b, c, d] with k=3 will consider the
    windows: [a,b,c], [b,c,d]. In the first window,
    a_b, a_c, and b_c appear; in the second window,
    b_c, c_d, and b_d appear. This example is in the
    doctest below.
    Note that the order of the tokens in the feature name
    matches the order in which they appear in the document.
    (e.g., a__b, not b__a)

    Params:
      tokens....array of token strings from a document.
      feats.....a dict from feature to value
      k.........the window size (3 by default)
    Returns:
      nothing; feats is modified in place.

    >>> feats = defaultdict(lambda: 0)
    >>> token_pair_features(np.array(['a', 'b', 'c', 'd']), feats)
    >>> sorted(feats.items())
    [('token_pair=a__b', 1), ('token_pair=a__c', 1), ('token_pair=b__c', 2), ('token_pair=b__d', 1), ('token_pair=c__d', 1)]
    """ 
    #TODO
    #track=0
    i=0
    j=1
    #for i in tokens:
    while(i<len(tokens)):
        #lol=tokens.tolist.index(i)
        while((j<i+3)and(j!=len(tokens))and(abs(i-j)<3)):
            #print(j)
                q=tokens[i]+'_'+tokens[j]
                if(not feats['token_pair='+q]):
                    feats['token_pair='+q]=1;
                    j+=1
                elif(feats['token_pair='+q]):
                    feats['token_pair='+q]+=1;
                    j+=1
                else:
                     pass
        if(j==i+3):
              j=i+2;
        i+=1
       # if(i=len(tokens)):
        #    i=track+1
         #   track+=1
        #else:
         #   pass
 
neg_words = set(['bad', 'hate', 'horrible', 'worst', 'boring'])
pos_words = set(['awesome', 'amazing', 'best', 'good', 'great', 'love', 'wonderful'])

def lexicon_features(tokens, feats):
    """
    Add features indicating how many time a token appears that matches either
    the neg_words or pos_words (defined above). The matching should ignore
    case.

    Params:
      tokens...array of token strings from a document.
      feats....dict from feature name to frequency
    Returns:
      nothing; feats is modified in place.

    In this example, 'LOVE' and 'great' match the pos_words,
    and 'boring' matches the neg_words list.
    >>> feats = defaultdict(lambda: 0)
    >>> lexicon_features(np.array(['i', 'LOVE', 'this', 'great', 'boring', 'movie']), feats)
    >>> sorted(feats.items())
    [('neg_words', 1), ('pos_words', 2)]
    """ 
    #TODO
    feats['pos_words']=0
    feats['neg_words']=0
    for n in tokens:
        i = n.lower()
        if(i in pos_words):
            feats['pos_words'] += 1
        elif(i in neg_words):
            feats['neg_words'] += 1
        else:
            pass
        
def featurize(tokens, feature_fns):
    """
    Compute all features for a list of tokens from
    a single document.

    Params:
      tokens........array of token strings from a document.
      feature_fns...a list of functions, one per feature
    Returns:
      list of (feature, value) tuples, SORTED alphabetically
      by the feature name.

    >>> feats = featurize(np.array(['i', 'LOVE', 'this', 'great', 'movie']), [token_features, lexicon_features])
    >>> feats
    [('neg_words', 0), ('pos_words', 2), ('token=LOVE', 1), ('token=great', 1), ('token=i', 1), ('token=movie', 1), ('token=this', 1)]
    """
    #TODO
    #i=0
    output=defaultdict(lambda:0)
    #feature_fns=[]
    #while (i<len(feature_fns)):
    for i in feature_fns:
        i(tokens,output)
        #for j in feats.keys():
         #   if(j not in output):
          #      output.append((j,feats[j]));    
    return output

def vectorize(tokens_list, feature_fns, min_freq, vocab=None):
    """
    Given the tokens for a set of documents, create a sparse
    feature matrix, where each row represents a document, and
    each column represents a feature.

    Params:
      tokens_list...a list of lists; each sublist is an
                    array of token strings from a document.
      feature_fns...a list of functions, one per feature
      min_freq......Remove features that do not appear in
                    at least min_freq different documents.
    Returns:
      - a csr_matrix: See https://goo.gl/f5TiF1 for documentation.
      This is a sparse matrix (zero values are not stored).
      - vocab: a dict from feature name to column index. NOTE
      that the columns are sorted alphabetically (so, the feature
      "token=great" is column 0 and "token=horrible" is column 1
      because "great" < "horrible" alphabetically),

    >>> docs = ["Isn't this movie great?", "Horrible, horrible movie"]
    >>> tokens_list = [tokenize(d) for d in docs]
    >>> feature_fns = [token_features]
    >>> X, vocab = vectorize(tokens_list, feature_fns, min_freq=1)
    >>> type(X)
    <class 'scipy.sparse.csr.csr_matrix'>
    >>> X.toarray()
    array([[1, 0, 1, 1, 1, 1],
           [0, 2, 0, 1, 0, 0]], dtype=int64)
    >>> sorted(vocab.items(), key=lambda x: x[1])
    [('token=great', 0), ('token=horrible', 1), ('token=isn', 2), ('token=movie', 3), ('token=t', 4), ('token=this', 5)]
    """
    #TODO
    bow=0
    data=[]
    indices=[]
    indptr=[0]
    voca={}
    for func in tokens_list:
        for i in feature_fns:
            i(func,feats)
            #print(func)
            #print(feats)
            for d in func:
                #print(d)
                while (bow<len(feats.keys())):
                    if(d in list(feats.keys())[bow]):
                        print(d)
                        print(bow)
                        #print(list(feats.keys())[bow])
                        index=voca.setdefault(list(feats.keys())[bow],len(voca))
                #print(index)
                        indices.append(index)
                #print(indices)
                        data.append(1)
            #print(data)
                        indptr.append(len(indices))
                        #bow=0
                        break
                    elif(d not in list(feats.keys())[bow]):
                        bow+=1
                    elif(bow==len(feats.keys())):
                        bow=0
                        break
                    else:
                        pass
                bow+=1
                bow=0;
                #print(indptr)
            #else:
                    #pass
    print(csr_matrix((data,indices,indptr),dtype=int).toarray())
    print(voca.items())
    #docs = [["hello", "world", "hello"], ["goodbye", "cruel", "world"]]
    #indptr = [0]
    #indices = []
    #data = []
    #vocabulary = {}
    #for d in docs:
     #   for term in d:
      #      index = vocabulary.setdefault(term, len(vocabulary))
       #     indices.append(index)
        #    data.append(1)
         #   indptr.append(len(indices))
#csr_matrix((data, indices, indptr), dtype=int).toarray()
    
def accuracy_score(truth, predicted):
    """ Compute accuracy of predictions.
    DONE ALREADY
    Params:
      truth.......array of true labels (0 or 1)
      predicted...array of predicted labels (0 or 1)
    """
    return len(np.where(truth==predicted)[0]) / len(truth)
def cross_validation_accuracy(clf, X, labels, k):
    """
    Compute the average testing accuracy over k folds of cross-validation. You
    can use sklearn's KFold class here (no random seed, and no shuffling
    needed).

    Params:
      clf......A LogisticRegression classifier.
      X........A csr_matrix of features.
      labels...The true labels for each instance in X
      k........The number of cross-validation folds.

    Returns:
      The average testing accuracy of the classifier
      over each fold of cross-validation.
    """
    ###TODO
