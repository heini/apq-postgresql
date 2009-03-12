/****************************************************************************/
/*                          APQ DATABASE BINDINGS                           */
/*                                                                          */
/*                            A P Q - POSTGRESQL			    */
/*                                                                          */
/*		                  S p e c                                   */
/*                                                                          */
/*         Copyright (C) 2002-2007, Warren W. Gay VE3WWG                    */
/*         Copyright (C) 2007-2009, Ada Works Project                       */
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

#ifndef _DECIMAL_H_
#define _DECIMAL_H_ 1

#include "pgtypes.h"
#include "numeric.h"

enum Num_Exception {
	No_Error = 0,
	Numeric_Format,
	Numeric_Overflow,
	Undefined_Result,
	Divide_By_Zero
};
typedef enum Num_Exception Decimal_Exception;

extern int	numeric_global_rscale(void);				/* Initial value for global_rscale */
extern void	numeric_free(Numeric num);				/* Free storage used by Numeric */

extern int	numeric_isnan(Numeric num);				/* Test for NaN */
extern Numeric	numeric_nan(void);					/* Create a NaN */

extern Numeric	numeric_in(const char *str,int precision,int scale,Decimal_Exception *ex);
extern char *	numeric_out(Numeric num);		/* Numeric to String */
extern Numeric	numeric(Numeric num, int precision, int scale, Decimal_Exception *ex);

extern Numeric	numeric_abs(Numeric num);				/* Absolute value */
extern Numeric	numeric_uminus(Numeric num);				/* Unary minus */
extern Numeric	numeric_uplus(Numeric num);				/* Copy value */
extern Numeric	numeric_sign(Numeric num);				/* Determine sign */
extern Numeric	numeric_round(Numeric num,int scale);			/* Round */
extern Numeric 	numeric_trunc(Numeric num,int scale);			/* Truncate */
extern Numeric	numeric_ceil(Numeric num);				/* Ceiling */
extern Numeric	numeric_floor(Numeric num);				/* Floor */

extern int	numeric_cmp(Numeric num1, Numeric num2);		/* Compare */
extern int	numeric_eq(Numeric num1, Numeric num2);			/* = */
extern int	numeric_ne(Numeric num1, Numeric num2);			/* != */
extern int	numeric_gt(Numeric num1, Numeric num2);			/* >  */
extern int	numeric_ge(Numeric num1, Numeric num2);			/* >= */
extern int	numeric_lt(Numeric num1, Numeric num2);			/* <  */
extern int	numeric_le(Numeric num1, Numeric num2);			/* <= */

extern Numeric	numeric_add(Numeric num1, Numeric num2);		/* + */
extern Numeric 	numeric_sub(Numeric num1, Numeric num2);		/* - */
extern Numeric 	numeric_mul(Numeric num1, Numeric num2, int *global_rscale);		/* * */
extern Numeric 	numeric_div(Numeric num1, Numeric num2, int *global_rscale, Decimal_Exception *ex);	/* / */
extern Numeric 	numeric_mod(Numeric num1, Numeric num2, int *global_rscale, Decimal_Exception *ex); /* % */

extern Numeric	numeric_smaller(Numeric num1, Numeric num2);		/* min(a,b) */
extern Numeric	numeric_larger(Numeric num1, Numeric num2);		/* max(a,b) */

extern Numeric	numeric_sqrt(Numeric num, int *global_rscale,Decimal_Exception *ex);	/* Square root */
extern Numeric	numeric_exp(Numeric num, int *global_rscale, Decimal_Exception *ex);	/* Exponent */
extern Numeric	numeric_ln(Numeric num, int *global_rscale, Decimal_Exception *ex);	/* Ln */
extern Numeric	numeric_log(Numeric num1, Numeric num2, int *global_rscale, Decimal_Exception *ex);   	/* Log */
extern Numeric	numeric_power(Numeric num1, Numeric num2, int *global_rscale, Decimal_Exception *ex);	/* Power */

#endif /* _DECIMAL_H_ */

/* End $Source: /cvsroot/apq/apq/decimal.h,v $ */
