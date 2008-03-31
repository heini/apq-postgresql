/****************************************************************************/
/*                          APQ DATABASE BINDINGS                           */
/*                                                                          */
/*                            A P Q - POSTGRESQL			    */
/*                                                                          */
/*		                  S p e c                                   */
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


#ifndef _PG_NUMERIC_H_
#define _PG_NUMERIC_H_

/* ----------
 * The hardcoded limits and defaults of the numeric data type
 * ----------
 */
#define NUMERIC_MAX_PRECISION		1000
#define NUMERIC_DEFAULT_PRECISION	30
#define NUMERIC_DEFAULT_SCALE		6


/* ----------
 * Internal limits on the scales chosen for calculation results
 * ----------
 */
#define NUMERIC_MAX_DISPLAY_SCALE	NUMERIC_MAX_PRECISION
#define NUMERIC_MIN_DISPLAY_SCALE	(NUMERIC_DEFAULT_SCALE + 4)

#define NUMERIC_MAX_RESULT_SCALE	(NUMERIC_MAX_PRECISION * 2)
#define NUMERIC_MIN_RESULT_SCALE	(NUMERIC_DEFAULT_PRECISION + 4)

/* ----------
 * Sign values and macros to deal with packing/unpacking n_sign_dscale
 * ----------
 */
#define NUMERIC_SIGN_MASK	0xC000
#define NUMERIC_POS			0x0000
#define NUMERIC_NEG			0x4000
#define NUMERIC_NAN			0xC000
#define NUMERIC_DSCALE_MASK 0x3FFF
#define NUMERIC_SIGN(n)		((n)->n_sign_dscale & NUMERIC_SIGN_MASK)
#define NUMERIC_DSCALE(n)	((n)->n_sign_dscale & NUMERIC_DSCALE_MASK)
#define NUMERIC_IS_NAN(n)	(NUMERIC_SIGN(n) != NUMERIC_POS &&			\
								NUMERIC_SIGN(n) != NUMERIC_NEG)

/* ----------
 * The Numeric data type stored in the database
 *
 * NOTE: by convention, values in the packed form have been stripped of
 * all leading and trailing zeroes (except there will be a trailing zero
 * in the last byte, if the number of digits is odd).  In particular,
 * if the value is zero, there will be no digits at all!  The weight is
 * arbitrary in that case, but we normally set it to zero.
 * ----------
 */
typedef struct NumericData
{
	int32		varlen;			/* Variable size		*/
	int16		n_weight;		/* Weight of 1st digit	*/
	uint16		n_rscale;		/* Result scale			*/
	uint16		n_sign_dscale;	/* Sign + display scale */
	unsigned char n_data[1];	/* Digit data (2 decimal digits/byte) */
} NumericData;
typedef NumericData *Numeric;

#define NUMERIC_HDRSZ	(sizeof(int32) + sizeof(uint16) * 3)

#endif   /* _PG_NUMERIC_H_ */
