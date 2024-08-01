# Hamster Alert!
# OS Final Project
# Emma Ruckle and Caroline Zouloumian

import smtplib
from gpiozero import MotionSensor

# function creates an SMTP server object and then sends mail via that object when called
# currently only sends a string message, cannot send attachments
def sendText(smtpServer: str, port: int, sendUsername: str, sendPassword: str, receiveUsername: str, text: str) :
    # init SMTP server object, open connection to server
    server = smtplib.SMTP(smtpServer, port)
    # client sends this to identify itself
    server.ehlo()
    # for security, encrypts all the SMTP commands
    server.starttls()
    # log in with sending email and sending email password
    server.login(sendUsername, sendPassword)
    # send the message, text, from the sending email to the receiving email
    server.sendmail(sendUsername, receiveUsername, text)
    # ends SMTP connection
    server.quit()

def main():
    # gmail's email server domain
    smtpServer = "smtp.gmail.com"
    # gmails SMTP port, if not using gmail it tends to be 25 for SMTP
    port = 587
    # sending email
    sendUser = "duckyhamstercam@gmail.com"
    # sending email's app password
    sendPass = "tjgl tlvn wpmq btej"
    # receiving email - utilizing Verizon's email to sms service so <phone number>@vtext.com
    # can also be a normal email account
    receiveEmail = "6035313488@vtext.com"
    # init motion sensor connected with GPIO 14
    pir = MotionSensor(14)
    while(1):
        # pause until motion is detected
        pir.wait_for_motion()
        # when motion is detected, send message by calling sendText function
        sendText(smtpServer, port, sendUser, sendPass, receiveEmail, "Duck is awake!")
        # pause until pir sensor is deactivated (by not detecing motion)
        pir.wait_for_no_motion()

if __name__ == "__main__":
    main()
