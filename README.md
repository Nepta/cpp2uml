cpp2uml
=======

parse c++ header file to make an uml diagram

This lua script output a plantuml script used to generate uml diagram

USAGE:
------
$ find ~/Project/AwesomeCppProject/ -name *.h | ./cpptouml.lua | plantuml -pipe > uml.png
