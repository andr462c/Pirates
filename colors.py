c = "83a2c6"
c1=c[0:2]
c2=c[2:4]
c3=c[4:6]

print("vec4(",",".join([str(int(col,16)/255) for col in [c1,c2,c3]]), ",1.0)")
    