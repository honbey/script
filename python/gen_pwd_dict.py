import itertools as its

words = "abcdefghijklmnopqrstuvwxyzABCDFEGHIJKLMNOPQRSTUVWXYZ0123456789"
r = its.product(words, repeat=8)
dic = open(r"pwd.txt", "a")
for i in r:
    dic.write("".join(i))
    dic.write("".join("\n"))
    print(i)
dic.close()
print("Generated Done.")
