## Illustration of NMF and other matrix magic

Denis Schluppeck, July 2024

## Non-negative matrix factorisation

- [famous paper by Lee & Seung](https://www.nature.com/articles/44565) in Nature that kick-started a lot of interest.

- there is whole field / many different algorithms, elaborations, etc.

- some ready-to-use packages. Here, we'll use `julia` and various packages that people have written to have a look.

- I also make use of some faces from a database at Amherst that cotains [labelled faces in the wild](https://vis-www.cs.umass.edu/lfw/#:~:text=All%20images%20aligned%20with%20deep%20funneling)

```bash
# download
curl http://vis-www.cs.umass.edu/lfw/lfw-deepfunneled.tgz > lfw-deep.tgz
# unpack
tar xvfz lfw-deepfunneled.tgz
```
