#! /usr/bin/python
# -*- coding: utf-8 -*-
import sklearn
import pandas as pd
from sklearn import datasets
from sklearn import linear_model

# irisのデータを用意
iris = datasets.load_iris()
X = iris.data
y = iris.target

# ランダムにシャッフルするためのモジュール
from sklearn.model_selection import ShuffleSplit
ss = ShuffleSplit(n_splits=1,
                  train_size=0.7,
                  test_size=0.3)

# シャッフルしたインデックスを取得
train_index, test_index = next(ss.split(X))
# print(train_index, test_index)

# 学習データとテストデータをそれぞれ取得
X_train, y_train = X[train_index], y[train_index]
X_test, y_test = X[test_index], y[test_index]

# ロジスティック回帰の識別器を用意
clf = linear_model.LogisticRegression()

# 識別器を学習させる
clf.fit(X_train, y_train)

# テストデータで識別結果を確認
print(clf.score(X_test, y_test))

