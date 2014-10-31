#!/bin/sh
curl -s --user 'api:key-558eb6f09593220c381e0039992d0719' \
  https://api.mailgun.net/v2/wansaleh.com/messages \
  -F from='Wan Saleh <saya@wansaleh.com>' \
  -F to=wansaleh@gmail.com \
  -F subject='Hello' \
  -F text='Testing some Mailgun awesomness!'
