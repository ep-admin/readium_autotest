require 'net/smtp'

class MyMail
  def initialize(emailServer, port, domain, account, password)
    @emailServer = emailServer
    @port = port
    @domain = domain
    @account = account
    @password = password
  end
  
  def send_mail_auth_plain(message, from, to)
    Net::SMTP.start(@emailServer, @port, @domain, @account, @password, :plain) do |smtp|
      smtp.send_message message, from, to

    end
  end
  
  def send_mail_to_exchange_srv(message, fromaccount, toaccounts)
    Net::SMTP.start(@emailServer) do |smtp|
        smtp.sendmail( message,  fromaccount, toaccounts )
    end
  end
  
  
end



isTestPOP3 = false
isTestExchange = false
if isTestPOP3
  emailserver = 'smtpout.secureserver.net'
  port = 25
  domain = 'evidentpoint.com'
  account = 'tuser@evidentpoint.com'
  password = 'test123'
  from = 'tuser@evidentpoint.com'
  to = ['borise@evidentpoint.com', 'tuser@evidentpoint.com']

  myMessage = "From: tuser@evidentpoint.com\nTo: borise@evidentpoint\nSubject: Test message\n\nMessage body here\n"
  a = MyMail.new(emailserver, port, domain, account, password)
  a.send_mail_auth_plain(myMessage, from, to)
  
elsif isTestExchange
  emailserver = 'epsrv03'
  fromaccount = 'b.estrin@evidentpoint.com'
  toaccounts = ['b.estrin@evidentpoint.com']
  message = "From: Test User\nTo: Acceptance User\nSubject: Test message\n\nMessage body here\n"
  
  a = MyMail.new(emailserver, "", "", "", "")  
  a.send_mail_to_exchange_srv(message, fromaccount, toaccounts)
  
  
end
