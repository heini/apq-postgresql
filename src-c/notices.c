/****************************************************************************/
/*                          APQ DATABASE BINDINGS                           */
/*                                                                          */
/*                            A P Q - POSTGRESQL			    */
/*                                                                          */
/*		                  B o d y                                   */
/*                                                                          */
/*         Copyright (C) 2002-2007, Warren W. Gay VE3WWG                    */
/*         Copyright (C) 2007-2008, Ydea Desenv. de Softwares Ltda          */
/*                                                                          */
/*                                                                          */
/* APQ is free software;  you can  redistribute it  and/or modify it under  */
/* terms of the  GNU General Public License as published  by the Free Soft- */
/* ware  Foundation;  either version 2,  or (at your option) any later ver- */
/* sion.  APQ is distributed in the hope that it will be useful, but WITH-  */
/* OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY */
/* or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License */
/* for  more details.  You should have  received  a copy of the GNU General */
/* Public License  distributed with APQ;  see file COPYING.  If not, write  */
/* to  the Free Software Foundation,  59 Temple Place - Suite 330,  Boston, */
/* MA 02111-1307, USA.                                                      */
/*                                                                          */
/* As a special exception,  if other files  instantiate  generics from this */
/* unit, or you link  this unit with other files  to produce an executable, */
/* this  unit  does not  by itself cause  the resulting  executable  to  be */
/* covered  by the  GNU  General  Public  License.  This exception does not */
/* however invalidate  any other reasons why  the executable file  might be */
/* covered by the  GNU Public License.                                      */
/****************************************************************************/

#include <stdio.h>
#include <libpq-fe.h>

/*
 * Connection_Notify is an Ada procedure using C calling convention :
 */
extern void Connection_Notify(void *arg,const char *message);

/*
 * A do-nothing notices callback :
 */
static void
notices_dud(void *arg,const char *message) {
	return;
}

/*
 * Install a new notices callback :
 */
void
notice_install(PGconn *conn,void *ada_obj_ptr) {
	PQsetNoticeProcessor(conn,Connection_Notify,ada_obj_ptr);
}

/*
 * Disable callbacks to the Connection_Notify Ada procedure :
 */
void
notice_uninstall(PGconn *conn) {
	PQsetNoticeProcessor(conn,notices_dud,NULL);
}

/* End $Source: /cvsroot/apq/apq/notices.c,v $ */
