------------------------------------------------------------------------------
--                                                                          --
--                          APQ DATABASE BINDINGS                           --
--                                                                          --
--                                  A P Q                                   --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--         Copyright (C) 2002-2007, Warren W. Gay VE3WWG                    --
--         Copyright (C) 2007-2008, Marcelo C. de Freitas (OgRo)            --
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
--                                                                          --
------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- This is the base package for the PostreSQL driver for APQ.                --
-------------------------------------------------------------------------------

package APQ.PostgreSQL is

	pragma Linker_Options("-lpq");
	
	type Result_Type is (
		Empty_Query,
		Command_OK,
		Tuples_OK,
		Copy_Out,
		Copy_In,
		Bad_Response,
		Nonfatal_Error,
		Fatal_Error
		);
	
	for Result_Type use (
		Empty_Query		=> 0,
		Command_OK		=> 1,
		Tuples_OK		=> 2,
		Copy_Out			=> 3,
		Copy_In			=> 4,
		Bad_Response	=> 5,
		Nonfatal_Error	=> 6,
		Fatal_Error		=> 7 
		);
	
	
	subtype PG_Smallint is APQ_Smallint;			-- For compatibility only (use APQ.Row_ID_Type instead)
	subtype PG_Integer is APQ_Integer;			-- For compatibility only (use APQ.Row_ID_Type instead)
	subtype PG_Bigint is APQ_Bigint;			-- For compatibility only (use APQ.Row_ID_Type instead)
	subtype PG_Real is APQ_Real;				-- For compatibility only (use APQ.Row_ID_Type instead)
	subtype PG_Double is APQ_Double;			-- For compatibility only (use APQ.Row_ID_Type instead)
	subtype PG_Serial is APQ_Serial;			-- For compatibility only (use APQ.Row_ID_Type instead)
	subtype PG_Bigserial is APQ_Bigserial;			-- For compatibility only (use APQ.Row_ID_Type instead)
	
	subtype PG_Oid is APQ.Row_ID_Type;			-- For compatibility only (use APQ.Row_ID_Type instead)
	subtype PG_Boolean is Boolean;				-- For compatibility only (use APQ_Boolean or Boolean instead)
	subtype PG_Date is APQ_Date;				-- For compatibility only (use APQ_Date instead)
	subtype PG_Time is APQ_Time;				-- For compatibility only (use APQ_Time instead)
	subtype PG_Timestamp is APQ_Timestamp;			-- For compatibility only (use APQ_Timestamp instead)
	subtype PG_Timezone is APQ_Timezone;			-- For compatibility only (use APQ_Timestamp instead)
	subtype PG_Bitstring is APQ_Bitstring;			-- For compatibility only (use APQ_Timestamp instead)
	
	type Mode_Type is (
		Write,
		Read,
		Read_Write
		);
	for Mode_Type use (
		Write		=> 16#00020000#,	-- Write access
		Read		=> 16#00040000#,	-- Read access
		Read_Write	=> 16#00060000#		-- Read/Write access
		);
	for Mode_Type'Size use 32;
	
private

	type PQOid_Type is mod 2 ** 32;			-- Currently PostgreSQL uses unsigned int for Oid
	
	Null_Row_ID : constant Row_ID_Type := 0;	-- Value representing no OID

end APQ.PostgreSQL;
