#!/usr/bin/python
# -*- encoding: utf-8 -*-
"""
  Script to decode Psi passwords stored in config.xml file.

  The code is based on psi-0.12 sources, so it's distributed under
  the same license.

  Copyright (C) 2008  Leonid Evdokimov <leon@darkk.net.ru>

  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License
  as published by the Free Software Foundation; either version 2
  of the License, or (at your option) any later version.
 
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
 
  You should have received a copy of the GNU General Public License
  along with this library; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

  Origin:
  http://darkk.net.ru/home/bin/psi-pass-dump.py

  Changelog:
  0.1 - Initial revision.
"""


def encodePassword(password, key):
    """
    // psi-0.12/src/common.cpp:113:QString encodePassword(const QString &pass, const QString &key)
    QString encodePassword(const QString &pass, const QString &key)
    {
            QString result;
            int n1, n2;

            if(key.length() == 0)
                    return pass;

            for(n1 = 0, n2 = 0; n1 < pass.length(); ++n1) {
                    ushort x = pass.at(n1).unicode() ^ key.at(n2++).unicode();
                    QString hex;
                    hex.sprintf("%04x", x);
                    result += hex;
                    if(n2 >= key.length())
                            n2 = 0;
            }
            return result;
    }
    """
    if len(key) == 0:
        return password

    result = u""
    for offset, char in enumerate(password):
        x = ord(char) ^ ord(key[offset % len(key)])
        result += "%04x" % x
    return result


def decodePassword(password, key):
    """
    // psi-0.12/src/common.cpp:132:QString decodePassword(const QString &pass, const QString &key)
    QString decodePassword(const QString &pass, const QString &key)
    {       
            QString result;
            int n1, n2;

            if(key.length() == 0)
                    return pass;

            for(n1 = 0, n2 = 0; n1 < pass.length(); n1 += 4) {
                    ushort x = 0;
                    if(n1 + 4 > pass.length())
                            break;
                    x += QString(pass.at(n1)).toInt(NULL,16)*4096;
                    x += QString(pass.at(n1+1)).toInt(NULL,16)*256;
                    x += QString(pass.at(n1+2)).toInt(NULL,16)*16;
                    x += QString(pass.at(n1+3)).toInt(NULL,16);
                    QChar c(x ^ key.at(n2++).unicode());
                    result += c;
                    if(n2 >= key.length())
                            n2 = 0;
            }
            return result;
    }
    """
    if len(key) == 0:
        return password

    assert len(password) % 4 == 0

    result = u""
    password = [int(password[i:i+4], 16) for i in xrange(0, len(password), 4)]
    for offset, char in enumerate(password):
        x = char ^ ord(key[offset % len(key)])
        result += unichr(x)
    return result


if __name__ == '__main__':
    import xml.etree.ElementTree as ElementTree
    import os.path
    tree = ElementTree.parse(os.path.expanduser('~/.psi/profiles/default/config.xml'))
    for acc in tree.findall('//accounts/account'):
        jid = acc.findtext('jid')
        password = acc.findtext('password')
        if password:
            print jid, decodePassword(password, jid)
        else:
            print jid, u"«None»"

# vim:set tabstop=4 softtabstop=4 shiftwidth=4: 
# vim:set expandtab: 
