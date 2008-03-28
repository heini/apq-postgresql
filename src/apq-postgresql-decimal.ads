------------------------------------------------------------------------------
--                                                                          --
--                          APQ DATABASE BINDINGS                           --
--                                                                          --
--                            A P Q - POSTGRESQL 			    --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--         Copyright (C) 2002-2007, Warren W. Gay VE3WWG                    --
--         Copyright (C) 2007-2008, Ydea Desenv. de Softwares Ltda          --
--                                                                          --
--                                                                          --
-- APQ is free software;  you can  redistribute it  and/or modify it under  --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 2,  or (at your option) any later ver- --
-- sion.  APQ is distributed in the hope that it will be useful, but WITH-  --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
-- for  more details.  You should have  received  a copy of the GNU General --
-- Public License  distributed with APQ;  see file COPYING.  If not, write  --
-- to  the Free Software Foundation,  59 Temple Place - Suite 330,  Boston, --
-- MA 02111-1307, USA.                                                      --
--                                                                          --
-- As a special exception,  if other files  instantiate  generics from this --
-- unit, or you link  this unit with other files  to produce an executable, --
-- this  unit  does not  by itself cause  the resulting  executable  to  be --
-- covered  by the  GNU  General  Public  License.  This exception does not --
-- however invalidate  any other reasons why  the executable file  might be --
-- covered by the  GNU Public License.                                      --
------------------------------------------------------------------------------

with System;
with Interfaces;
with Ada.Finalization;
with APQ.PostgreSQL.Client;

package APQ.PostgreSQL.Decimal is

	Decimal_NaN :		exception;
	Decimal_Format :	exception;
	Decimal_Overflow :	exception;
	Undefined_Result :	exception;
	Divide_By_Zero :	exception;

	type Decimal_Type is new Ada.Finalization.Controlled with private;

	type Precision_Type is range 0..32767;		-- Implementation may not actually live up to these limits
	type Scale_Type is range 0..32767;		-- Ditto.

	function Is_Nan(DT : Decimal_Type) return Boolean;

	procedure Convert(DT : in out Decimal_Type; S : String; Precision : Precision_Type := 0; Scale : Scale_Type := 2);
	function To_String(DT : Decimal_Type) return String;
	function Constrain(DT : Decimal_Type; Precision : Precision_Type; Scale : Scale_Type) return Decimal_Type;

	function Abs_Value(DT : Decimal_Type) return Decimal_Type;
	function Sign(DT : Decimal_Type) return Decimal_Type;
	function Ceil(DT : Decimal_Type) return Decimal_Type;
	function Floor(DT : Decimal_Type) return Decimal_Type;

	function Round(DT : Decimal_Type; Scale : Scale_Type) return Decimal_Type;
	function Trunc(DT : Decimal_Type; Scale : Scale_Type) return Decimal_Type;

	function Min_Value(Left, Right : Decimal_Type) return Decimal_Type;
	function Max_Value(Left, Right : Decimal_Type) return Decimal_Type;

	function Sqrt(X : Decimal_Type) return Decimal_Type;
	function Exp(X : Decimal_Type) return Decimal_Type;
	function Ln(X : Decimal_Type) return Decimal_Type;
	function Log10(X : Decimal_Type) return Decimal_Type;

	function Log(X, Base : Decimal_Type) return Decimal_Type;
	function Power(X, Y : Decimal_Type) return Decimal_Type;

	function "+"(Left, Right : Decimal_Type) return Decimal_Type;
	function "-"(Left, Right : Decimal_Type) return Decimal_Type;
	function "-"(DT : Decimal_Type) return Decimal_Type;
	function "*"(Left, Right : Decimal_Type) return Decimal_Type;
	function "/"(Left, Right : Decimal_Type) return Decimal_Type;

	function "="(Left, Right : Decimal_Type) return Boolean;
	function ">"(Left, Right : Decimal_Type) return Boolean;
	function ">="(Left, Right : Decimal_Type) return Boolean;
	function "<"(Left, Right : Decimal_Type) return Boolean;
	function "<="(Left, Right : Decimal_Type) return Boolean;

	function NaN return Decimal_Type;
	function Zero return Decimal_Type;
	function One return Decimal_Type;
	function Two return Decimal_Type;
	function Ten return Decimal_Type;

	procedure Append(Query : in out PostgreSQL.Client.Query_Type; DT : Decimal_Type'Class; After : String := "");
	function Value(Query : PostgreSQL.Client.Query_Type; CX : Column_Index_Type) return Decimal_Type;

private

	type Rscale_Type is range -2 ** 31 .. 2 ** 31 - 1;
	type Numeric_Type is new System.Address;

	Null_Numeric : constant Numeric_Type := Numeric_Type(System.Null_Address);

	type Decimal_Type is new Ada.Finalization.Controlled with
		record
			Global_Rscale :	Rscale_Type;
			Precision :	Precision_Type := 0;
			Scale :		Scale_Type := 0;
			Numeric :	Numeric_Type := Null_Numeric;
		end record;

	procedure Initialize(DT : in out Decimal_Type);
	procedure Finalize(DT : in out Decimal_Type);
	procedure Adjust(DT : in out Decimal_Type);

end APQ.PostgreSQL.Decimal;

-- End $Source: /cvsroot/apq/apq/apq-postgresql-decimal.ads,v $
