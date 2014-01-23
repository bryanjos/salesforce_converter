# SalesforceConverter

A small Elixir program to try to figure out the file types from a backup from Salesforce

Compile:
```
mix deps.get
mix escriptize
```

Usage:

If you have a directory tree that looks like the following:
```
\
  \backup
    \Attachments
    \Documents
```

Then you would use it like this:

```
./salesforce_converter \backup
```
