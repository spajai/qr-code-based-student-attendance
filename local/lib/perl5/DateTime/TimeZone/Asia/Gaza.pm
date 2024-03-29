# This file is auto-generated by the Perl DateTime Suite time zone
# code generator (0.08) This code generator comes with the
# DateTime::TimeZone module distribution in the tools/ directory

#
# Generated from /tmp/ehRi0awH48/asia.  Olson data version 2022f
#
# Do not edit this file directly.
#
package DateTime::TimeZone::Asia::Gaza;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '2.56';

use Class::Singleton 1.03;
use DateTime::TimeZone;
use DateTime::TimeZone::OlsonDB;

@DateTime::TimeZone::Asia::Gaza::ISA = ( 'Class::Singleton', 'DateTime::TimeZone' );

my $spans =
[
    [
DateTime::TimeZone::NEG_INFINITY, #    utc_start
59950273328, #      utc_end 1900-09-30 21:42:08 (Sun)
DateTime::TimeZone::NEG_INFINITY, #  local_start
59950281600, #    local_end 1900-10-01 00:00:00 (Mon)
8272,
0,
'LMT',
    ],
    [
59950273328, #    utc_start 1900-09-30 21:42:08 (Sun)
61202044800, #      utc_end 1940-06-01 00:00:00 (Sat)
59950280528, #  local_start 1900-09-30 23:42:08 (Sun)
61202052000, #    local_end 1940-06-01 02:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
61202044800, #    utc_start 1940-06-01 00:00:00 (Sat)
61212585600, #      utc_end 1940-10-01 00:00:00 (Tue)
61202055600, #  local_start 1940-06-01 03:00:00 (Sat)
61212596400, #    local_end 1940-10-01 03:00:00 (Tue)
10800,
1,
'EEST',
    ],
    [
61212585600, #    utc_start 1940-10-01 00:00:00 (Tue)
61216646400, #      utc_end 1940-11-17 00:00:00 (Sun)
61212592800, #  local_start 1940-10-01 02:00:00 (Tue)
61216653600, #    local_end 1940-11-17 02:00:00 (Sun)
7200,
0,
'EET',
    ],
    [
61216646400, #    utc_start 1940-11-17 00:00:00 (Sun)
61278336000, #      utc_end 1942-11-01 00:00:00 (Sun)
61216657200, #  local_start 1940-11-17 03:00:00 (Sun)
61278346800, #    local_end 1942-11-01 03:00:00 (Sun)
10800,
1,
'EEST',
    ],
    [
61278336000, #    utc_start 1942-11-01 00:00:00 (Sun)
61291382400, #      utc_end 1943-04-01 00:00:00 (Thu)
61278343200, #  local_start 1942-11-01 02:00:00 (Sun)
61291389600, #    local_end 1943-04-01 02:00:00 (Thu)
7200,
0,
'EET',
    ],
    [
61291382400, #    utc_start 1943-04-01 00:00:00 (Thu)
61309872000, #      utc_end 1943-11-01 00:00:00 (Mon)
61291393200, #  local_start 1943-04-01 03:00:00 (Thu)
61309882800, #    local_end 1943-11-01 03:00:00 (Mon)
10800,
1,
'EEST',
    ],
    [
61309872000, #    utc_start 1943-11-01 00:00:00 (Mon)
61323004800, #      utc_end 1944-04-01 00:00:00 (Sat)
61309879200, #  local_start 1943-11-01 02:00:00 (Mon)
61323012000, #    local_end 1944-04-01 02:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
61323004800, #    utc_start 1944-04-01 00:00:00 (Sat)
61341494400, #      utc_end 1944-11-01 00:00:00 (Wed)
61323015600, #  local_start 1944-04-01 03:00:00 (Sat)
61341505200, #    local_end 1944-11-01 03:00:00 (Wed)
10800,
1,
'EEST',
    ],
    [
61341494400, #    utc_start 1944-11-01 00:00:00 (Wed)
61355836800, #      utc_end 1945-04-16 00:00:00 (Mon)
61341501600, #  local_start 1944-11-01 02:00:00 (Wed)
61355844000, #    local_end 1945-04-16 02:00:00 (Mon)
7200,
0,
'EET',
    ],
    [
61355836800, #    utc_start 1945-04-16 00:00:00 (Mon)
61373030400, #      utc_end 1945-11-01 00:00:00 (Thu)
61355847600, #  local_start 1945-04-16 03:00:00 (Mon)
61373041200, #    local_end 1945-11-01 03:00:00 (Thu)
10800,
1,
'EEST',
    ],
    [
61373030400, #    utc_start 1945-11-01 00:00:00 (Thu)
61387372800, #      utc_end 1946-04-16 00:00:00 (Tue)
61373037600, #  local_start 1945-11-01 02:00:00 (Thu)
61387380000, #    local_end 1946-04-16 02:00:00 (Tue)
7200,
0,
'EET',
    ],
    [
61387372800, #    utc_start 1946-04-16 00:00:00 (Tue)
61404566400, #      utc_end 1946-11-01 00:00:00 (Fri)
61387383600, #  local_start 1946-04-16 03:00:00 (Tue)
61404577200, #    local_end 1946-11-01 03:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
61404566400, #    utc_start 1946-11-01 00:00:00 (Fri)
61453029600, #      utc_end 1948-05-14 22:00:00 (Fri)
61404573600, #  local_start 1946-11-01 02:00:00 (Fri)
61453036800, #    local_end 1948-05-15 00:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
61453029600, #    utc_start 1948-05-14 22:00:00 (Fri)
61736594400, #      utc_end 1957-05-09 22:00:00 (Thu)
61453036800, #  local_start 1948-05-15 00:00:00 (Sat)
61736601600, #    local_end 1957-05-10 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
61736594400, #    utc_start 1957-05-09 22:00:00 (Thu)
61749032400, #      utc_end 1957-09-30 21:00:00 (Mon)
61736605200, #  local_start 1957-05-10 01:00:00 (Fri)
61749043200, #    local_end 1957-10-01 00:00:00 (Tue)
10800,
1,
'EEST',
    ],
    [
61749032400, #    utc_start 1957-09-30 21:00:00 (Mon)
61767352800, #      utc_end 1958-04-30 22:00:00 (Wed)
61749039600, #  local_start 1957-09-30 23:00:00 (Mon)
61767360000, #    local_end 1958-05-01 00:00:00 (Thu)
7200,
0,
'EET',
    ],
    [
61767352800, #    utc_start 1958-04-30 22:00:00 (Wed)
61780568400, #      utc_end 1958-09-30 21:00:00 (Tue)
61767363600, #  local_start 1958-05-01 01:00:00 (Thu)
61780579200, #    local_end 1958-10-01 00:00:00 (Wed)
10800,
1,
'EEST',
    ],
    [
61780568400, #    utc_start 1958-09-30 21:00:00 (Tue)
61798892400, #      utc_end 1959-04-30 23:00:00 (Thu)
61780575600, #  local_start 1958-09-30 23:00:00 (Tue)
61798899600, #    local_end 1959-05-01 01:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
61798892400, #    utc_start 1959-04-30 23:00:00 (Thu)
61812028800, #      utc_end 1959-09-30 00:00:00 (Wed)
61798903200, #  local_start 1959-05-01 02:00:00 (Fri)
61812039600, #    local_end 1959-09-30 03:00:00 (Wed)
10800,
1,
'EEST',
    ],
    [
61812028800, #    utc_start 1959-09-30 00:00:00 (Wed)
61830514800, #      utc_end 1960-04-30 23:00:00 (Sat)
61812036000, #  local_start 1959-09-30 02:00:00 (Wed)
61830522000, #    local_end 1960-05-01 01:00:00 (Sun)
7200,
0,
'EET',
    ],
    [
61830514800, #    utc_start 1960-04-30 23:00:00 (Sat)
61843651200, #      utc_end 1960-09-30 00:00:00 (Fri)
61830525600, #  local_start 1960-05-01 02:00:00 (Sun)
61843662000, #    local_end 1960-09-30 03:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
61843651200, #    utc_start 1960-09-30 00:00:00 (Fri)
61862050800, #      utc_end 1961-04-30 23:00:00 (Sun)
61843658400, #  local_start 1960-09-30 02:00:00 (Fri)
61862058000, #    local_end 1961-05-01 01:00:00 (Mon)
7200,
0,
'EET',
    ],
    [
61862050800, #    utc_start 1961-04-30 23:00:00 (Sun)
61875187200, #      utc_end 1961-09-30 00:00:00 (Sat)
61862061600, #  local_start 1961-05-01 02:00:00 (Mon)
61875198000, #    local_end 1961-09-30 03:00:00 (Sat)
10800,
1,
'EEST',
    ],
    [
61875187200, #    utc_start 1961-09-30 00:00:00 (Sat)
61893586800, #      utc_end 1962-04-30 23:00:00 (Mon)
61875194400, #  local_start 1961-09-30 02:00:00 (Sat)
61893594000, #    local_end 1962-05-01 01:00:00 (Tue)
7200,
0,
'EET',
    ],
    [
61893586800, #    utc_start 1962-04-30 23:00:00 (Mon)
61906723200, #      utc_end 1962-09-30 00:00:00 (Sun)
61893597600, #  local_start 1962-05-01 02:00:00 (Tue)
61906734000, #    local_end 1962-09-30 03:00:00 (Sun)
10800,
1,
'EEST',
    ],
    [
61906723200, #    utc_start 1962-09-30 00:00:00 (Sun)
61925122800, #      utc_end 1963-04-30 23:00:00 (Tue)
61906730400, #  local_start 1962-09-30 02:00:00 (Sun)
61925130000, #    local_end 1963-05-01 01:00:00 (Wed)
7200,
0,
'EET',
    ],
    [
61925122800, #    utc_start 1963-04-30 23:00:00 (Tue)
61938259200, #      utc_end 1963-09-30 00:00:00 (Mon)
61925133600, #  local_start 1963-05-01 02:00:00 (Wed)
61938270000, #    local_end 1963-09-30 03:00:00 (Mon)
10800,
1,
'EEST',
    ],
    [
61938259200, #    utc_start 1963-09-30 00:00:00 (Mon)
61956745200, #      utc_end 1964-04-30 23:00:00 (Thu)
61938266400, #  local_start 1963-09-30 02:00:00 (Mon)
61956752400, #    local_end 1964-05-01 01:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
61956745200, #    utc_start 1964-04-30 23:00:00 (Thu)
61969881600, #      utc_end 1964-09-30 00:00:00 (Wed)
61956756000, #  local_start 1964-05-01 02:00:00 (Fri)
61969892400, #    local_end 1964-09-30 03:00:00 (Wed)
10800,
1,
'EEST',
    ],
    [
61969881600, #    utc_start 1964-09-30 00:00:00 (Wed)
61988281200, #      utc_end 1965-04-30 23:00:00 (Fri)
61969888800, #  local_start 1964-09-30 02:00:00 (Wed)
61988288400, #    local_end 1965-05-01 01:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
61988281200, #    utc_start 1965-04-30 23:00:00 (Fri)
62001417600, #      utc_end 1965-09-30 00:00:00 (Thu)
61988292000, #  local_start 1965-05-01 02:00:00 (Sat)
62001428400, #    local_end 1965-09-30 03:00:00 (Thu)
10800,
1,
'EEST',
    ],
    [
62001417600, #    utc_start 1965-09-30 00:00:00 (Thu)
62019817200, #      utc_end 1966-04-30 23:00:00 (Sat)
62001424800, #  local_start 1965-09-30 02:00:00 (Thu)
62019824400, #    local_end 1966-05-01 01:00:00 (Sun)
7200,
0,
'EET',
    ],
    [
62019817200, #    utc_start 1966-04-30 23:00:00 (Sat)
62033040000, #      utc_end 1966-10-01 00:00:00 (Sat)
62019828000, #  local_start 1966-05-01 02:00:00 (Sun)
62033050800, #    local_end 1966-10-01 03:00:00 (Sat)
10800,
1,
'EEST',
    ],
    [
62033040000, #    utc_start 1966-10-01 00:00:00 (Sat)
62051353200, #      utc_end 1967-04-30 23:00:00 (Sun)
62033047200, #  local_start 1966-10-01 02:00:00 (Sat)
62051360400, #    local_end 1967-05-01 01:00:00 (Mon)
7200,
0,
'EET',
    ],
    [
62051353200, #    utc_start 1967-04-30 23:00:00 (Sun)
62054370000, #      utc_end 1967-06-04 21:00:00 (Sun)
62051364000, #  local_start 1967-05-01 02:00:00 (Mon)
62054380800, #    local_end 1967-06-05 00:00:00 (Mon)
10800,
1,
'EEST',
    ],
    [
62054370000, #    utc_start 1967-06-04 21:00:00 (Sun)
62278063200, #      utc_end 1974-07-06 22:00:00 (Sat)
62054377200, #  local_start 1967-06-04 23:00:00 (Sun)
62278070400, #    local_end 1974-07-07 00:00:00 (Sun)
7200,
0,
'IST',
    ],
    [
62278063200, #    utc_start 1974-07-06 22:00:00 (Sat)
62286526800, #      utc_end 1974-10-12 21:00:00 (Sat)
62278074000, #  local_start 1974-07-07 01:00:00 (Sun)
62286537600, #    local_end 1974-10-13 00:00:00 (Sun)
10800,
1,
'IDT',
    ],
    [
62286526800, #    utc_start 1974-10-12 21:00:00 (Sat)
62302860000, #      utc_end 1975-04-19 22:00:00 (Sat)
62286534000, #  local_start 1974-10-12 23:00:00 (Sat)
62302867200, #    local_end 1975-04-20 00:00:00 (Sun)
7200,
0,
'IST',
    ],
    [
62302860000, #    utc_start 1975-04-19 22:00:00 (Sat)
62314347600, #      utc_end 1975-08-30 21:00:00 (Sat)
62302870800, #  local_start 1975-04-20 01:00:00 (Sun)
62314358400, #    local_end 1975-08-31 00:00:00 (Sun)
10800,
1,
'IDT',
    ],
    [
62314347600, #    utc_start 1975-08-30 21:00:00 (Sat)
62469784800, #      utc_end 1980-08-02 22:00:00 (Sat)
62314354800, #  local_start 1975-08-30 23:00:00 (Sat)
62469792000, #    local_end 1980-08-03 00:00:00 (Sun)
7200,
0,
'IST',
    ],
    [
62469784800, #    utc_start 1980-08-02 22:00:00 (Sat)
62473413600, #      utc_end 1980-09-13 22:00:00 (Sat)
62469795600, #  local_start 1980-08-03 01:00:00 (Sun)
62473424400, #    local_end 1980-09-14 01:00:00 (Sun)
10800,
1,
'IDT',
    ],
    [
62473413600, #    utc_start 1980-09-13 22:00:00 (Sat)
62588325600, #      utc_end 1984-05-05 22:00:00 (Sat)
62473420800, #  local_start 1980-09-14 00:00:00 (Sun)
62588332800, #    local_end 1984-05-06 00:00:00 (Sun)
7200,
0,
'IST',
    ],
    [
62588325600, #    utc_start 1984-05-05 22:00:00 (Sat)
62598002400, #      utc_end 1984-08-25 22:00:00 (Sat)
62588336400, #  local_start 1984-05-06 01:00:00 (Sun)
62598013200, #    local_end 1984-08-26 01:00:00 (Sun)
10800,
1,
'IDT',
    ],
    [
62598002400, #    utc_start 1984-08-25 22:00:00 (Sat)
62617960800, #      utc_end 1985-04-13 22:00:00 (Sat)
62598009600, #  local_start 1984-08-26 00:00:00 (Sun)
62617968000, #    local_end 1985-04-14 00:00:00 (Sun)
7200,
0,
'IST',
    ],
    [
62617960800, #    utc_start 1985-04-13 22:00:00 (Sat)
62630053200, #      utc_end 1985-08-31 21:00:00 (Sat)
62617971600, #  local_start 1985-04-14 01:00:00 (Sun)
62630064000, #    local_end 1985-09-01 00:00:00 (Sun)
10800,
1,
'IDT',
    ],
    [
62630053200, #    utc_start 1985-08-31 21:00:00 (Sat)
62652434400, #      utc_end 1986-05-17 22:00:00 (Sat)
62630060400, #  local_start 1985-08-31 23:00:00 (Sat)
62652441600, #    local_end 1986-05-18 00:00:00 (Sun)
7200,
0,
'IST',
    ],
    [
62652434400, #    utc_start 1986-05-17 22:00:00 (Sat)
62662107600, #      utc_end 1986-09-06 21:00:00 (Sat)
62652445200, #  local_start 1986-05-18 01:00:00 (Sun)
62662118400, #    local_end 1986-09-07 00:00:00 (Sun)
10800,
1,
'IDT',
    ],
    [
62662107600, #    utc_start 1986-09-06 21:00:00 (Sat)
62681119200, #      utc_end 1987-04-14 22:00:00 (Tue)
62662114800, #  local_start 1986-09-06 23:00:00 (Sat)
62681126400, #    local_end 1987-04-15 00:00:00 (Wed)
7200,
0,
'IST',
    ],
    [
62681119200, #    utc_start 1987-04-14 22:00:00 (Tue)
62694162000, #      utc_end 1987-09-12 21:00:00 (Sat)
62681130000, #  local_start 1987-04-15 01:00:00 (Wed)
62694172800, #    local_end 1987-09-13 00:00:00 (Sun)
10800,
1,
'IDT',
    ],
    [
62694162000, #    utc_start 1987-09-12 21:00:00 (Sat)
62712309600, #      utc_end 1988-04-09 22:00:00 (Sat)
62694169200, #  local_start 1987-09-12 23:00:00 (Sat)
62712316800, #    local_end 1988-04-10 00:00:00 (Sun)
7200,
0,
'IST',
    ],
    [
62712309600, #    utc_start 1988-04-09 22:00:00 (Sat)
62725006800, #      utc_end 1988-09-03 21:00:00 (Sat)
62712320400, #  local_start 1988-04-10 01:00:00 (Sun)
62725017600, #    local_end 1988-09-04 00:00:00 (Sun)
10800,
1,
'IDT',
    ],
    [
62725006800, #    utc_start 1988-09-03 21:00:00 (Sat)
62745573600, #      utc_end 1989-04-29 22:00:00 (Sat)
62725014000, #  local_start 1988-09-03 23:00:00 (Sat)
62745580800, #    local_end 1989-04-30 00:00:00 (Sun)
7200,
0,
'IST',
    ],
    [
62745573600, #    utc_start 1989-04-29 22:00:00 (Sat)
62756456400, #      utc_end 1989-09-02 21:00:00 (Sat)
62745584400, #  local_start 1989-04-30 01:00:00 (Sun)
62756467200, #    local_end 1989-09-03 00:00:00 (Sun)
10800,
1,
'IDT',
    ],
    [
62756456400, #    utc_start 1989-09-02 21:00:00 (Sat)
62773999200, #      utc_end 1990-03-24 22:00:00 (Sat)
62756463600, #  local_start 1989-09-02 23:00:00 (Sat)
62774006400, #    local_end 1990-03-25 00:00:00 (Sun)
7200,
0,
'IST',
    ],
    [
62773999200, #    utc_start 1990-03-24 22:00:00 (Sat)
62787301200, #      utc_end 1990-08-25 21:00:00 (Sat)
62774010000, #  local_start 1990-03-25 01:00:00 (Sun)
62787312000, #    local_end 1990-08-26 00:00:00 (Sun)
10800,
1,
'IDT',
    ],
    [
62787301200, #    utc_start 1990-08-25 21:00:00 (Sat)
62805448800, #      utc_end 1991-03-23 22:00:00 (Sat)
62787308400, #  local_start 1990-08-25 23:00:00 (Sat)
62805456000, #    local_end 1991-03-24 00:00:00 (Sun)
7200,
0,
'IST',
    ],
    [
62805448800, #    utc_start 1991-03-23 22:00:00 (Sat)
62819355600, #      utc_end 1991-08-31 21:00:00 (Sat)
62805459600, #  local_start 1991-03-24 01:00:00 (Sun)
62819366400, #    local_end 1991-09-01 00:00:00 (Sun)
10800,
1,
'IDT',
    ],
    [
62819355600, #    utc_start 1991-08-31 21:00:00 (Sat)
62837503200, #      utc_end 1992-03-28 22:00:00 (Sat)
62819362800, #  local_start 1991-08-31 23:00:00 (Sat)
62837510400, #    local_end 1992-03-29 00:00:00 (Sun)
7200,
0,
'IST',
    ],
    [
62837503200, #    utc_start 1992-03-28 22:00:00 (Sat)
62851410000, #      utc_end 1992-09-05 21:00:00 (Sat)
62837514000, #  local_start 1992-03-29 01:00:00 (Sun)
62851420800, #    local_end 1992-09-06 00:00:00 (Sun)
10800,
1,
'IDT',
    ],
    [
62851410000, #    utc_start 1992-09-05 21:00:00 (Sat)
62869384800, #      utc_end 1993-04-01 22:00:00 (Thu)
62851417200, #  local_start 1992-09-05 23:00:00 (Sat)
62869392000, #    local_end 1993-04-02 00:00:00 (Fri)
7200,
0,
'IST',
    ],
    [
62869384800, #    utc_start 1993-04-01 22:00:00 (Thu)
62882859600, #      utc_end 1993-09-04 21:00:00 (Sat)
62869395600, #  local_start 1993-04-02 01:00:00 (Fri)
62882870400, #    local_end 1993-09-05 00:00:00 (Sun)
10800,
1,
'IDT',
    ],
    [
62882859600, #    utc_start 1993-09-04 21:00:00 (Sat)
62900834400, #      utc_end 1994-03-31 22:00:00 (Thu)
62882866800, #  local_start 1993-09-04 23:00:00 (Sat)
62900841600, #    local_end 1994-04-01 00:00:00 (Fri)
7200,
0,
'IST',
    ],
    [
62900834400, #    utc_start 1994-03-31 22:00:00 (Thu)
62913704400, #      utc_end 1994-08-27 21:00:00 (Sat)
62900845200, #  local_start 1994-04-01 01:00:00 (Fri)
62913715200, #    local_end 1994-08-28 00:00:00 (Sun)
10800,
1,
'IDT',
    ],
    [
62913704400, #    utc_start 1994-08-27 21:00:00 (Sat)
62932284000, #      utc_end 1995-03-30 22:00:00 (Thu)
62913711600, #  local_start 1994-08-27 23:00:00 (Sat)
62932291200, #    local_end 1995-03-31 00:00:00 (Fri)
7200,
0,
'IST',
    ],
    [
62932284000, #    utc_start 1995-03-30 22:00:00 (Thu)
62945758800, #      utc_end 1995-09-02 21:00:00 (Sat)
62932294800, #  local_start 1995-03-31 01:00:00 (Fri)
62945769600, #    local_end 1995-09-03 00:00:00 (Sun)
10800,
1,
'IDT',
    ],
    [
62945758800, #    utc_start 1995-09-02 21:00:00 (Sat)
62956130400, #      utc_end 1995-12-31 22:00:00 (Sun)
62945766000, #  local_start 1995-09-02 23:00:00 (Sat)
62956137600, #    local_end 1996-01-01 00:00:00 (Mon)
7200,
0,
'IST',
    ],
    [
62956130400, #    utc_start 1995-12-31 22:00:00 (Sun)
62964338400, #      utc_end 1996-04-04 22:00:00 (Thu)
62956137600, #  local_start 1996-01-01 00:00:00 (Mon)
62964345600, #    local_end 1996-04-05 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
62964338400, #    utc_start 1996-04-04 22:00:00 (Thu)
62978853600, #      utc_end 1996-09-19 22:00:00 (Thu)
62964349200, #  local_start 1996-04-05 01:00:00 (Fri)
62978864400, #    local_end 1996-09-20 01:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
62978853600, #    utc_start 1996-09-19 22:00:00 (Thu)
62995788000, #      utc_end 1997-04-03 22:00:00 (Thu)
62978860800, #  local_start 1996-09-20 00:00:00 (Fri)
62995795200, #    local_end 1997-04-04 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
62995788000, #    utc_start 1997-04-03 22:00:00 (Thu)
63010303200, #      utc_end 1997-09-18 22:00:00 (Thu)
62995798800, #  local_start 1997-04-04 01:00:00 (Fri)
63010314000, #    local_end 1997-09-19 01:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
63010303200, #    utc_start 1997-09-18 22:00:00 (Thu)
63027237600, #      utc_end 1998-04-02 22:00:00 (Thu)
63010310400, #  local_start 1997-09-19 00:00:00 (Fri)
63027244800, #    local_end 1998-04-03 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
63027237600, #    utc_start 1998-04-02 22:00:00 (Thu)
63041752800, #      utc_end 1998-09-17 22:00:00 (Thu)
63027248400, #  local_start 1998-04-03 01:00:00 (Fri)
63041763600, #    local_end 1998-09-18 01:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
63041752800, #    utc_start 1998-09-17 22:00:00 (Thu)
63050824800, #      utc_end 1998-12-31 22:00:00 (Thu)
63041760000, #  local_start 1998-09-18 00:00:00 (Fri)
63050832000, #    local_end 1999-01-01 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
63050824800, #    utc_start 1998-12-31 22:00:00 (Thu)
63059896800, #      utc_end 1999-04-15 22:00:00 (Thu)
63050832000, #  local_start 1999-01-01 00:00:00 (Fri)
63059904000, #    local_end 1999-04-16 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
63059896800, #    utc_start 1999-04-15 22:00:00 (Thu)
63075618000, #      utc_end 1999-10-14 21:00:00 (Thu)
63059907600, #  local_start 1999-04-16 01:00:00 (Fri)
63075628800, #    local_end 1999-10-15 00:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
63075618000, #    utc_start 1999-10-14 21:00:00 (Thu)
63091951200, #      utc_end 2000-04-20 22:00:00 (Thu)
63075625200, #  local_start 1999-10-14 23:00:00 (Thu)
63091958400, #    local_end 2000-04-21 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
63091951200, #    utc_start 2000-04-20 22:00:00 (Thu)
63107672400, #      utc_end 2000-10-19 21:00:00 (Thu)
63091962000, #  local_start 2000-04-21 01:00:00 (Fri)
63107683200, #    local_end 2000-10-20 00:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
63107672400, #    utc_start 2000-10-19 21:00:00 (Thu)
63123400800, #      utc_end 2001-04-19 22:00:00 (Thu)
63107679600, #  local_start 2000-10-19 23:00:00 (Thu)
63123408000, #    local_end 2001-04-20 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
63123400800, #    utc_start 2001-04-19 22:00:00 (Thu)
63139122000, #      utc_end 2001-10-18 21:00:00 (Thu)
63123411600, #  local_start 2001-04-20 01:00:00 (Fri)
63139132800, #    local_end 2001-10-19 00:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
63139122000, #    utc_start 2001-10-18 21:00:00 (Thu)
63154850400, #      utc_end 2002-04-18 22:00:00 (Thu)
63139129200, #  local_start 2001-10-18 23:00:00 (Thu)
63154857600, #    local_end 2002-04-19 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
63154850400, #    utc_start 2002-04-18 22:00:00 (Thu)
63170571600, #      utc_end 2002-10-17 21:00:00 (Thu)
63154861200, #  local_start 2002-04-19 01:00:00 (Fri)
63170582400, #    local_end 2002-10-18 00:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
63170571600, #    utc_start 2002-10-17 21:00:00 (Thu)
63186300000, #      utc_end 2003-04-17 22:00:00 (Thu)
63170578800, #  local_start 2002-10-17 23:00:00 (Thu)
63186307200, #    local_end 2003-04-18 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
63186300000, #    utc_start 2003-04-17 22:00:00 (Thu)
63202021200, #      utc_end 2003-10-16 21:00:00 (Thu)
63186310800, #  local_start 2003-04-18 01:00:00 (Fri)
63202032000, #    local_end 2003-10-17 00:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
63202021200, #    utc_start 2003-10-16 21:00:00 (Thu)
63217749600, #      utc_end 2004-04-15 22:00:00 (Thu)
63202028400, #  local_start 2003-10-16 23:00:00 (Thu)
63217756800, #    local_end 2004-04-16 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
63217749600, #    utc_start 2004-04-15 22:00:00 (Thu)
63232264800, #      utc_end 2004-09-30 22:00:00 (Thu)
63217760400, #  local_start 2004-04-16 01:00:00 (Fri)
63232275600, #    local_end 2004-10-01 01:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
63232264800, #    utc_start 2004-09-30 22:00:00 (Thu)
63249199200, #      utc_end 2005-04-14 22:00:00 (Thu)
63232272000, #  local_start 2004-10-01 00:00:00 (Fri)
63249206400, #    local_end 2005-04-15 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
63249199200, #    utc_start 2005-04-14 22:00:00 (Thu)
63264063600, #      utc_end 2005-10-03 23:00:00 (Mon)
63249210000, #  local_start 2005-04-15 01:00:00 (Fri)
63264074400, #    local_end 2005-10-04 02:00:00 (Tue)
10800,
1,
'EEST',
    ],
    [
63264063600, #    utc_start 2005-10-03 23:00:00 (Mon)
63279525600, #      utc_end 2006-03-31 22:00:00 (Fri)
63264070800, #  local_start 2005-10-04 01:00:00 (Tue)
63279532800, #    local_end 2006-04-01 00:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
63279525600, #    utc_start 2006-03-31 22:00:00 (Fri)
63294555600, #      utc_end 2006-09-21 21:00:00 (Thu)
63279536400, #  local_start 2006-04-01 01:00:00 (Sat)
63294566400, #    local_end 2006-09-22 00:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
63294555600, #    utc_start 2006-09-21 21:00:00 (Thu)
63311061600, #      utc_end 2007-03-31 22:00:00 (Sat)
63294562800, #  local_start 2006-09-21 23:00:00 (Thu)
63311068800, #    local_end 2007-04-01 00:00:00 (Sun)
7200,
0,
'EET',
    ],
    [
63311061600, #    utc_start 2007-03-31 22:00:00 (Sat)
63325321200, #      utc_end 2007-09-12 23:00:00 (Wed)
63311072400, #  local_start 2007-04-01 01:00:00 (Sun)
63325332000, #    local_end 2007-09-13 02:00:00 (Thu)
10800,
1,
'EEST',
    ],
    [
63325321200, #    utc_start 2007-09-12 23:00:00 (Wed)
63342338400, #      utc_end 2008-03-27 22:00:00 (Thu)
63325328400, #  local_start 2007-09-13 01:00:00 (Thu)
63342345600, #    local_end 2008-03-28 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
63342338400, #    utc_start 2008-03-27 22:00:00 (Thu)
63355640400, #      utc_end 2008-08-28 21:00:00 (Thu)
63342349200, #  local_start 2008-03-28 01:00:00 (Fri)
63355651200, #    local_end 2008-08-29 00:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
63355640400, #    utc_start 2008-08-28 21:00:00 (Thu)
63355903200, #      utc_end 2008-08-31 22:00:00 (Sun)
63355647600, #  local_start 2008-08-28 23:00:00 (Thu)
63355910400, #    local_end 2008-09-01 00:00:00 (Mon)
7200,
0,
'EET',
    ],
    [
63355903200, #    utc_start 2008-08-31 22:00:00 (Sun)
63373788000, #      utc_end 2009-03-26 22:00:00 (Thu)
63355910400, #  local_start 2008-09-01 00:00:00 (Mon)
63373795200, #    local_end 2009-03-27 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
63373788000, #    utc_start 2009-03-26 22:00:00 (Thu)
63387698400, #      utc_end 2009-09-03 22:00:00 (Thu)
63373798800, #  local_start 2009-03-27 01:00:00 (Fri)
63387709200, #    local_end 2009-09-04 01:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
63387698400, #    utc_start 2009-09-03 22:00:00 (Thu)
63397980000, #      utc_end 2009-12-31 22:00:00 (Thu)
63387705600, #  local_start 2009-09-04 00:00:00 (Fri)
63397987200, #    local_end 2010-01-01 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
63397980000, #    utc_start 2009-12-31 22:00:00 (Thu)
63405324060, #      utc_end 2010-03-26 22:01:00 (Fri)
63397987200, #  local_start 2010-01-01 00:00:00 (Fri)
63405331260, #    local_end 2010-03-27 00:01:00 (Sat)
7200,
0,
'EET',
    ],
    [
63405324060, #    utc_start 2010-03-26 22:01:00 (Fri)
63417157200, #      utc_end 2010-08-10 21:00:00 (Tue)
63405334860, #  local_start 2010-03-27 01:01:00 (Sat)
63417168000, #    local_end 2010-08-11 00:00:00 (Wed)
10800,
1,
'EEST',
    ],
    [
63417157200, #    utc_start 2010-08-10 21:00:00 (Tue)
63437292060, #      utc_end 2011-03-31 22:01:00 (Thu)
63417164400, #  local_start 2010-08-10 23:00:00 (Tue)
63437299260, #    local_end 2011-04-01 00:01:00 (Fri)
7200,
0,
'EET',
    ],
    [
63437292060, #    utc_start 2011-03-31 22:01:00 (Thu)
63447829200, #      utc_end 2011-07-31 21:00:00 (Sun)
63437302860, #  local_start 2011-04-01 01:01:00 (Fri)
63447840000, #    local_end 2011-08-01 00:00:00 (Mon)
10800,
1,
'EEST',
    ],
    [
63447829200, #    utc_start 2011-07-31 21:00:00 (Sun)
63461052000, #      utc_end 2011-12-31 22:00:00 (Sat)
63447836400, #  local_start 2011-07-31 23:00:00 (Sun)
63461059200, #    local_end 2012-01-01 00:00:00 (Sun)
7200,
0,
'EET',
    ],
    [
63461052000, #    utc_start 2011-12-31 22:00:00 (Sat)
63468741600, #      utc_end 2012-03-29 22:00:00 (Thu)
63461059200, #  local_start 2012-01-01 00:00:00 (Sun)
63468748800, #    local_end 2012-03-30 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
63468741600, #    utc_start 2012-03-29 22:00:00 (Thu)
63483861600, #      utc_end 2012-09-20 22:00:00 (Thu)
63468752400, #  local_start 2012-03-30 01:00:00 (Fri)
63483872400, #    local_end 2012-09-21 01:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
63483861600, #    utc_start 2012-09-20 22:00:00 (Thu)
63500191200, #      utc_end 2013-03-28 22:00:00 (Thu)
63483868800, #  local_start 2012-09-21 00:00:00 (Fri)
63500198400, #    local_end 2013-03-29 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
63500191200, #    utc_start 2013-03-28 22:00:00 (Thu)
63515912400, #      utc_end 2013-09-26 21:00:00 (Thu)
63500202000, #  local_start 2013-03-29 01:00:00 (Fri)
63515923200, #    local_end 2013-09-27 00:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
63515912400, #    utc_start 2013-09-26 21:00:00 (Thu)
63531640800, #      utc_end 2014-03-27 22:00:00 (Thu)
63515919600, #  local_start 2013-09-26 23:00:00 (Thu)
63531648000, #    local_end 2014-03-28 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
63531640800, #    utc_start 2014-03-27 22:00:00 (Thu)
63549781200, #      utc_end 2014-10-23 21:00:00 (Thu)
63531651600, #  local_start 2014-03-28 01:00:00 (Fri)
63549792000, #    local_end 2014-10-24 00:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
63549781200, #    utc_start 2014-10-23 21:00:00 (Thu)
63563176800, #      utc_end 2015-03-27 22:00:00 (Fri)
63549788400, #  local_start 2014-10-23 23:00:00 (Thu)
63563184000, #    local_end 2015-03-28 00:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
63563176800, #    utc_start 2015-03-27 22:00:00 (Fri)
63581234400, #      utc_end 2015-10-22 22:00:00 (Thu)
63563187600, #  local_start 2015-03-28 01:00:00 (Sat)
63581245200, #    local_end 2015-10-23 01:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
63581234400, #    utc_start 2015-10-22 22:00:00 (Thu)
63594630000, #      utc_end 2016-03-25 23:00:00 (Fri)
63581241600, #  local_start 2015-10-23 00:00:00 (Fri)
63594637200, #    local_end 2016-03-26 01:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
63594630000, #    utc_start 2016-03-25 23:00:00 (Fri)
63613375200, #      utc_end 2016-10-28 22:00:00 (Fri)
63594640800, #  local_start 2016-03-26 02:00:00 (Sat)
63613386000, #    local_end 2016-10-29 01:00:00 (Sat)
10800,
1,
'EEST',
    ],
    [
63613375200, #    utc_start 2016-10-28 22:00:00 (Fri)
63626079600, #      utc_end 2017-03-24 23:00:00 (Fri)
63613382400, #  local_start 2016-10-29 00:00:00 (Sat)
63626086800, #    local_end 2017-03-25 01:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
63626079600, #    utc_start 2017-03-24 23:00:00 (Fri)
63644824800, #      utc_end 2017-10-27 22:00:00 (Fri)
63626090400, #  local_start 2017-03-25 02:00:00 (Sat)
63644835600, #    local_end 2017-10-28 01:00:00 (Sat)
10800,
1,
'EEST',
    ],
    [
63644824800, #    utc_start 2017-10-27 22:00:00 (Fri)
63657529200, #      utc_end 2018-03-23 23:00:00 (Fri)
63644832000, #  local_start 2017-10-28 00:00:00 (Sat)
63657536400, #    local_end 2018-03-24 01:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
63657529200, #    utc_start 2018-03-23 23:00:00 (Fri)
63676274400, #      utc_end 2018-10-26 22:00:00 (Fri)
63657540000, #  local_start 2018-03-24 02:00:00 (Sat)
63676285200, #    local_end 2018-10-27 01:00:00 (Sat)
10800,
1,
'EEST',
    ],
    [
63676274400, #    utc_start 2018-10-26 22:00:00 (Fri)
63689493600, #      utc_end 2019-03-28 22:00:00 (Thu)
63676281600, #  local_start 2018-10-27 00:00:00 (Sat)
63689500800, #    local_end 2019-03-29 00:00:00 (Fri)
7200,
0,
'EET',
    ],
    [
63689493600, #    utc_start 2019-03-28 22:00:00 (Thu)
63707720400, #      utc_end 2019-10-25 21:00:00 (Fri)
63689504400, #  local_start 2019-03-29 01:00:00 (Fri)
63707731200, #    local_end 2019-10-26 00:00:00 (Sat)
10800,
1,
'EEST',
    ],
    [
63707720400, #    utc_start 2019-10-25 21:00:00 (Fri)
63721029600, #      utc_end 2020-03-27 22:00:00 (Fri)
63707727600, #  local_start 2019-10-25 23:00:00 (Fri)
63721036800, #    local_end 2020-03-28 00:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
63721029600, #    utc_start 2020-03-27 22:00:00 (Fri)
63739173600, #      utc_end 2020-10-23 22:00:00 (Fri)
63721040400, #  local_start 2020-03-28 01:00:00 (Sat)
63739184400, #    local_end 2020-10-24 01:00:00 (Sat)
10800,
1,
'EEST',
    ],
    [
63739173600, #    utc_start 2020-10-23 22:00:00 (Fri)
63752479200, #      utc_end 2021-03-26 22:00:00 (Fri)
63739180800, #  local_start 2020-10-24 00:00:00 (Sat)
63752486400, #    local_end 2021-03-27 00:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
63752479200, #    utc_start 2021-03-26 22:00:00 (Fri)
63771141600, #      utc_end 2021-10-28 22:00:00 (Thu)
63752490000, #  local_start 2021-03-27 01:00:00 (Sat)
63771152400, #    local_end 2021-10-29 01:00:00 (Fri)
10800,
1,
'EEST',
    ],
    [
63771141600, #    utc_start 2021-10-28 22:00:00 (Thu)
63784015200, #      utc_end 2022-03-26 22:00:00 (Sat)
63771148800, #  local_start 2021-10-29 00:00:00 (Fri)
63784022400, #    local_end 2022-03-27 00:00:00 (Sun)
7200,
0,
'EET',
    ],
    [
63784015200, #    utc_start 2022-03-26 22:00:00 (Sat)
63802681200, #      utc_end 2022-10-28 23:00:00 (Fri)
63784026000, #  local_start 2022-03-27 01:00:00 (Sun)
63802692000, #    local_end 2022-10-29 02:00:00 (Sat)
10800,
1,
'EEST',
    ],
    [
63802681200, #    utc_start 2022-10-28 23:00:00 (Fri)
63815385600, #      utc_end 2023-03-25 00:00:00 (Sat)
63802688400, #  local_start 2022-10-29 01:00:00 (Sat)
63815392800, #    local_end 2023-03-25 02:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
63815385600, #    utc_start 2023-03-25 00:00:00 (Sat)
63834130800, #      utc_end 2023-10-27 23:00:00 (Fri)
63815396400, #  local_start 2023-03-25 03:00:00 (Sat)
63834141600, #    local_end 2023-10-28 02:00:00 (Sat)
10800,
1,
'EEST',
    ],
    [
63834130800, #    utc_start 2023-10-27 23:00:00 (Fri)
63847440000, #      utc_end 2024-03-30 00:00:00 (Sat)
63834138000, #  local_start 2023-10-28 01:00:00 (Sat)
63847447200, #    local_end 2024-03-30 02:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
63847440000, #    utc_start 2024-03-30 00:00:00 (Sat)
63865580400, #      utc_end 2024-10-25 23:00:00 (Fri)
63847450800, #  local_start 2024-03-30 03:00:00 (Sat)
63865591200, #    local_end 2024-10-26 02:00:00 (Sat)
10800,
1,
'EEST',
    ],
    [
63865580400, #    utc_start 2024-10-25 23:00:00 (Fri)
63878889600, #      utc_end 2025-03-29 00:00:00 (Sat)
63865587600, #  local_start 2024-10-26 01:00:00 (Sat)
63878896800, #    local_end 2025-03-29 02:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
63878889600, #    utc_start 2025-03-29 00:00:00 (Sat)
63897030000, #      utc_end 2025-10-24 23:00:00 (Fri)
63878900400, #  local_start 2025-03-29 03:00:00 (Sat)
63897040800, #    local_end 2025-10-25 02:00:00 (Sat)
10800,
1,
'EEST',
    ],
    [
63897030000, #    utc_start 2025-10-24 23:00:00 (Fri)
63910339200, #      utc_end 2026-03-28 00:00:00 (Sat)
63897037200, #  local_start 2025-10-25 01:00:00 (Sat)
63910346400, #    local_end 2026-03-28 02:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
63910339200, #    utc_start 2026-03-28 00:00:00 (Sat)
63928479600, #      utc_end 2026-10-23 23:00:00 (Fri)
63910350000, #  local_start 2026-03-28 03:00:00 (Sat)
63928490400, #    local_end 2026-10-24 02:00:00 (Sat)
10800,
1,
'EEST',
    ],
    [
63928479600, #    utc_start 2026-10-23 23:00:00 (Fri)
63941788800, #      utc_end 2027-03-27 00:00:00 (Sat)
63928486800, #  local_start 2026-10-24 01:00:00 (Sat)
63941796000, #    local_end 2027-03-27 02:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
63941788800, #    utc_start 2027-03-27 00:00:00 (Sat)
63960534000, #      utc_end 2027-10-29 23:00:00 (Fri)
63941799600, #  local_start 2027-03-27 03:00:00 (Sat)
63960544800, #    local_end 2027-10-30 02:00:00 (Sat)
10800,
1,
'EEST',
    ],
    [
63960534000, #    utc_start 2027-10-29 23:00:00 (Fri)
63973238400, #      utc_end 2028-03-25 00:00:00 (Sat)
63960541200, #  local_start 2027-10-30 01:00:00 (Sat)
63973245600, #    local_end 2028-03-25 02:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
63973238400, #    utc_start 2028-03-25 00:00:00 (Sat)
63991983600, #      utc_end 2028-10-27 23:00:00 (Fri)
63973249200, #  local_start 2028-03-25 03:00:00 (Sat)
63991994400, #    local_end 2028-10-28 02:00:00 (Sat)
10800,
1,
'EEST',
    ],
    [
63991983600, #    utc_start 2028-10-27 23:00:00 (Fri)
64004688000, #      utc_end 2029-03-24 00:00:00 (Sat)
63991990800, #  local_start 2028-10-28 01:00:00 (Sat)
64004695200, #    local_end 2029-03-24 02:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
64004688000, #    utc_start 2029-03-24 00:00:00 (Sat)
64023433200, #      utc_end 2029-10-26 23:00:00 (Fri)
64004698800, #  local_start 2029-03-24 03:00:00 (Sat)
64023444000, #    local_end 2029-10-27 02:00:00 (Sat)
10800,
1,
'EEST',
    ],
    [
64023433200, #    utc_start 2029-10-26 23:00:00 (Fri)
64036742400, #      utc_end 2030-03-30 00:00:00 (Sat)
64023440400, #  local_start 2029-10-27 01:00:00 (Sat)
64036749600, #    local_end 2030-03-30 02:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
64036742400, #    utc_start 2030-03-30 00:00:00 (Sat)
64054882800, #      utc_end 2030-10-25 23:00:00 (Fri)
64036753200, #  local_start 2030-03-30 03:00:00 (Sat)
64054893600, #    local_end 2030-10-26 02:00:00 (Sat)
10800,
1,
'EEST',
    ],
    [
64054882800, #    utc_start 2030-10-25 23:00:00 (Fri)
64068192000, #      utc_end 2031-03-29 00:00:00 (Sat)
64054890000, #  local_start 2030-10-26 01:00:00 (Sat)
64068199200, #    local_end 2031-03-29 02:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
64068192000, #    utc_start 2031-03-29 00:00:00 (Sat)
64086332400, #      utc_end 2031-10-24 23:00:00 (Fri)
64068202800, #  local_start 2031-03-29 03:00:00 (Sat)
64086343200, #    local_end 2031-10-25 02:00:00 (Sat)
10800,
1,
'EEST',
    ],
    [
64086332400, #    utc_start 2031-10-24 23:00:00 (Fri)
64099641600, #      utc_end 2032-03-27 00:00:00 (Sat)
64086339600, #  local_start 2031-10-25 01:00:00 (Sat)
64099648800, #    local_end 2032-03-27 02:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
64099641600, #    utc_start 2032-03-27 00:00:00 (Sat)
64118386800, #      utc_end 2032-10-29 23:00:00 (Fri)
64099652400, #  local_start 2032-03-27 03:00:00 (Sat)
64118397600, #    local_end 2032-10-30 02:00:00 (Sat)
10800,
1,
'EEST',
    ],
    [
64118386800, #    utc_start 2032-10-29 23:00:00 (Fri)
64131091200, #      utc_end 2033-03-26 00:00:00 (Sat)
64118394000, #  local_start 2032-10-30 01:00:00 (Sat)
64131098400, #    local_end 2033-03-26 02:00:00 (Sat)
7200,
0,
'EET',
    ],
    [
64131091200, #    utc_start 2033-03-26 00:00:00 (Sat)
64149836400, #      utc_end 2033-10-28 23:00:00 (Fri)
64131102000, #  local_start 2033-03-26 03:00:00 (Sat)
64149847200, #    local_end 2033-10-29 02:00:00 (Sat)
10800,
1,
'EEST',
    ],
];

sub olson_version {'2022f'}

sub has_dst_changes {70}

sub _max_year {2032}

sub _new_instance {
    return shift->_init( @_, spans => $spans );
}

sub _last_offset { 7200 }

my $last_observance = bless( {
  'format' => 'EE%sT',
  'gmtoff' => '2:00',
  'local_start_datetime' => bless( {
    'formatter' => undef,
    'local_rd_days' => 734503,
    'local_rd_secs' => 0,
    'offset_modifier' => 0,
    'rd_nanosecs' => 0,
    'tz' => bless( {
      'name' => 'floating',
      'offset' => 0
    }, 'DateTime::TimeZone::Floating' ),
    'utc_rd_days' => 734503,
    'utc_rd_secs' => 0,
    'utc_year' => 2013
  }, 'DateTime' ),
  'offset_from_std' => 0,
  'offset_from_utc' => 7200,
  'until' => [],
  'utc_start_datetime' => bless( {
    'formatter' => undef,
    'local_rd_days' => 734502,
    'local_rd_secs' => 79200,
    'offset_modifier' => 0,
    'rd_nanosecs' => 0,
    'tz' => bless( {
      'name' => 'floating',
      'offset' => 0
    }, 'DateTime::TimeZone::Floating' ),
    'utc_rd_days' => 734502,
    'utc_rd_secs' => 79200,
    'utc_year' => 2012
  }, 'DateTime' )
}, 'DateTime::TimeZone::OlsonDB::Observance' )
;
sub _last_observance { $last_observance }

my $rules = [
  bless( {
    'at' => '2:00',
    'from' => '2022',
    'in' => 'Oct',
    'letter' => '',
    'name' => 'Palestine',
    'offset_from_std' => 0,
    'on' => 'Sat<=30',
    'save' => '0',
    'to' => 'max'
  }, 'DateTime::TimeZone::OlsonDB::Rule' ),
  bless( {
    'at' => '2:00',
    'from' => '2023',
    'in' => 'Mar',
    'letter' => 'S',
    'name' => 'Palestine',
    'offset_from_std' => 3600,
    'on' => 'Sat<=30',
    'save' => '1:00',
    'to' => 'max'
  }, 'DateTime::TimeZone::OlsonDB::Rule' )
]
;
sub _rules { $rules }


1;

