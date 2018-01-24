pwnable.kr

the problem name was shellshock.

I've heard about it once, so I searched it on google.

It was a vulnerability for bash environment variable

`env var` could be a executable function.

this is a test code from [here](https://access.redhat.com/blogs/766093/posts/1976383)

```
env x='() { :;}; echo vulnerable' bash -c "echo this is a test"
```

when vulnerable shell is executed, the `env var` can be executed.

right now, I don't know much about it. but someday I'll look more. :cat:
