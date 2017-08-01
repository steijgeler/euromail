euromail
========

Gem to upload pdf data to an SFTP server, like Euromail. Filenames are generated
and consist of the application name, customer name and a given identifier.

Usage
=====

Create an instance of the Euromail::SFTPService like this:

```EUROMAIL = Euromail::SFTPService.new('some_company', 'some_customer', 'ftp.somehost.com', 'itsme', 'super_secret')```

Upload pdf data like this:

```EUROMAIL.upload!('pdf string', '213')```

Remove a pdf file like this:

```EUROMAIL.remove!('213')```

Development and test mode
=========================

In development mode a connection to the sftp server is never made. Instead, some information of connecting and
uploads is logged to $stdout.

In test mode a connection to the sftp server is never made, and nothing is logged. Instead, the 'EUROMAIL.uploaded_files'
array keeps track of the uploaded files.

Switch to development or test mode like this:

```
EUROMAIL.development_mode!
EUROMAIL.test_mode!
```

