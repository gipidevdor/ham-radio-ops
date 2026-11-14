package Ham::QSO::_Internal::ADIFData;
use 5.020;
use strict;
use warnings;
use JSON::PP;

# Factual ADIF 3.1.8 identifiers and constraints; no specification prose/schema.
# Source: https://adif.org.uk/318/ADIF_318.htm (2026-11-07).
# Original compilation: Giacomo Picchiarelli, Artistic License 2.0.
my $data;

sub registry {
    $data //= JSON::PP->new->decode(do { local $/ = undef; <DATA> });
    return $data;
}
1;
__DATA__
{
   "enums" : {
      "ANTPATH" : {
         "G" : {
            "import_only" : 0
         },
         "L" : {
            "import_only" : 0
         },
         "O" : {
            "import_only" : 0
         },
         "S" : {
            "import_only" : 0
         }
      },
      "ARRLSECTION" : {
         "AB" : {
            "import_only" : 0
         },
         "AK" : {
            "import_only" : 0
         },
         "AL" : {
            "import_only" : 0
         },
         "AR" : {
            "import_only" : 0
         },
         "AZ" : {
            "import_only" : 0
         },
         "BC" : {
            "import_only" : 0
         },
         "CO" : {
            "import_only" : 0
         },
         "CT" : {
            "import_only" : 0
         },
         "DE" : {
            "import_only" : 0
         },
         "EB" : {
            "import_only" : 0
         },
         "EMA" : {
            "import_only" : 0
         },
         "ENY" : {
            "import_only" : 0
         },
         "EPA" : {
            "import_only" : 0
         },
         "EWA" : {
            "import_only" : 0
         },
         "GA" : {
            "import_only" : 0
         },
         "GH" : {
            "import_only" : 0
         },
         "GTA" : {
            "import_only" : 0
         },
         "IA" : {
            "import_only" : 0
         },
         "ID" : {
            "import_only" : 0
         },
         "IL" : {
            "import_only" : 0
         },
         "IN" : {
            "import_only" : 0
         },
         "KS" : {
            "import_only" : 0
         },
         "KY" : {
            "import_only" : 0
         },
         "LA" : {
            "import_only" : 0
         },
         "LAX" : {
            "import_only" : 0
         },
         "MAR" : {
            "import_only" : 0
         },
         "MB" : {
            "import_only" : 0
         },
         "MDC" : {
            "import_only" : 0
         },
         "ME" : {
            "import_only" : 0
         },
         "MI" : {
            "import_only" : 0
         },
         "MN" : {
            "import_only" : 0
         },
         "MO" : {
            "import_only" : 0
         },
         "MS" : {
            "import_only" : 0
         },
         "MT" : {
            "import_only" : 0
         },
         "NB" : {
            "import_only" : 0
         },
         "NC" : {
            "import_only" : 0
         },
         "ND" : {
            "import_only" : 0
         },
         "NE" : {
            "import_only" : 0
         },
         "NFL" : {
            "import_only" : 0
         },
         "NH" : {
            "import_only" : 0
         },
         "NL" : {
            "import_only" : 0
         },
         "NLI" : {
            "import_only" : 0
         },
         "NM" : {
            "import_only" : 0
         },
         "NNJ" : {
            "import_only" : 0
         },
         "NNY" : {
            "import_only" : 0
         },
         "NS" : {
            "import_only" : 0
         },
         "NT" : {
            "import_only" : 0
         },
         "NTX" : {
            "import_only" : 0
         },
         "NV" : {
            "import_only" : 0
         },
         "NWT" : {
            "import_only" : 0
         },
         "OH" : {
            "import_only" : 0
         },
         "OK" : {
            "import_only" : 0
         },
         "ON" : {
            "import_only" : 0
         },
         "ONE" : {
            "import_only" : 0
         },
         "ONN" : {
            "import_only" : 0
         },
         "ONS" : {
            "import_only" : 0
         },
         "OR" : {
            "import_only" : 0
         },
         "ORG" : {
            "import_only" : 0
         },
         "PAC" : {
            "import_only" : 0
         },
         "PE" : {
            "import_only" : 0
         },
         "PR" : {
            "import_only" : 0
         },
         "QC" : {
            "import_only" : 0
         },
         "RI" : {
            "import_only" : 0
         },
         "SB" : {
            "import_only" : 0
         },
         "SC" : {
            "import_only" : 0
         },
         "SCV" : {
            "import_only" : 0
         },
         "SD" : {
            "import_only" : 0
         },
         "SDG" : {
            "import_only" : 0
         },
         "SF" : {
            "import_only" : 0
         },
         "SFL" : {
            "import_only" : 0
         },
         "SJV" : {
            "import_only" : 0
         },
         "SK" : {
            "import_only" : 0
         },
         "SNJ" : {
            "import_only" : 0
         },
         "STX" : {
            "import_only" : 0
         },
         "SV" : {
            "import_only" : 0
         },
         "TER" : {
            "import_only" : 0
         },
         "TN" : {
            "import_only" : 0
         },
         "UT" : {
            "import_only" : 0
         },
         "VA" : {
            "import_only" : 0
         },
         "VI" : {
            "import_only" : 0
         },
         "VT" : {
            "import_only" : 0
         },
         "WCF" : {
            "import_only" : 0
         },
         "WI" : {
            "import_only" : 0
         },
         "WMA" : {
            "import_only" : 0
         },
         "WNY" : {
            "import_only" : 0
         },
         "WPA" : {
            "import_only" : 0
         },
         "WTX" : {
            "import_only" : 0
         },
         "WV" : {
            "import_only" : 0
         },
         "WWA" : {
            "import_only" : 0
         },
         "WY" : {
            "import_only" : 0
         }
      },
      "AWARD" : {
         "AJA" : {
            "import_only" : 1
         },
         "CQDX" : {
            "import_only" : 1
         },
         "CQDXFIELD" : {
            "import_only" : 1
         },
         "CQWAZ_160M" : {
            "import_only" : 1
         },
         "CQWAZ_CW" : {
            "import_only" : 1
         },
         "CQWAZ_MIXED" : {
            "import_only" : 1
         },
         "CQWAZ_PHONE" : {
            "import_only" : 1
         },
         "CQWAZ_RTTY" : {
            "import_only" : 1
         },
         "CQWPX" : {
            "import_only" : 1
         },
         "DARC_DOK" : {
            "import_only" : 1
         },
         "DXCC" : {
            "import_only" : 1
         },
         "DXCC_CW" : {
            "import_only" : 1
         },
         "DXCC_MIXED" : {
            "import_only" : 1
         },
         "DXCC_PHONE" : {
            "import_only" : 1
         },
         "DXCC_RTTY" : {
            "import_only" : 1
         },
         "IOTA" : {
            "import_only" : 1
         },
         "JCC" : {
            "import_only" : 1
         },
         "JCG" : {
            "import_only" : 1
         },
         "MARATHON" : {
            "import_only" : 1
         },
         "RDA" : {
            "import_only" : 1
         },
         "USACA" : {
            "import_only" : 1
         },
         "VUCC" : {
            "import_only" : 1
         },
         "WAB" : {
            "import_only" : 1
         },
         "WAC" : {
            "import_only" : 1
         },
         "WAE" : {
            "import_only" : 1
         },
         "WAIP" : {
            "import_only" : 1
         },
         "WAJA" : {
            "import_only" : 1
         },
         "WAS" : {
            "import_only" : 1
         },
         "WAZ" : {
            "import_only" : 1
         }
      },
      "AWARDSPONSOR" : {
         "ADIF_" : {
            "import_only" : 0
         },
         "ARI_" : {
            "import_only" : 0
         },
         "ARRL_" : {
            "import_only" : 0
         },
         "CQ_" : {
            "import_only" : 0
         },
         "DARC_" : {
            "import_only" : 0
         },
         "EQSL_" : {
            "import_only" : 0
         },
         "IARU_" : {
            "import_only" : 0
         },
         "JARL_" : {
            "import_only" : 0
         },
         "RSGB_" : {
            "import_only" : 0
         },
         "TAG_" : {
            "import_only" : 0
         },
         "WABAG_" : {
            "import_only" : 0
         }
      },
      "BAND" : {
         "1.25CM" : {
            "import_only" : 0,
            "lower" : 24000,
            "upper" : 24250
         },
         "1.25M" : {
            "import_only" : 0,
            "lower" : 222,
            "upper" : 225
         },
         "10M" : {
            "import_only" : 0,
            "lower" : 28,
            "upper" : 29.7
         },
         "12M" : {
            "import_only" : 0,
            "lower" : 24.89,
            "upper" : 24.99
         },
         "13CM" : {
            "import_only" : 0,
            "lower" : 2300,
            "upper" : 2450
         },
         "15M" : {
            "import_only" : 0,
            "lower" : 21,
            "upper" : 21.45
         },
         "160M" : {
            "import_only" : 0,
            "lower" : 1.8,
            "upper" : 2
         },
         "17M" : {
            "import_only" : 0,
            "lower" : 18.068,
            "upper" : 18.168
         },
         "1MM" : {
            "import_only" : 0,
            "lower" : 241000,
            "upper" : 250000
         },
         "2.5MM" : {
            "import_only" : 0,
            "lower" : 119980,
            "upper" : 123000
         },
         "20M" : {
            "import_only" : 0,
            "lower" : 14,
            "upper" : 14.35
         },
         "2190M" : {
            "import_only" : 0,
            "lower" : 0.1357,
            "upper" : 0.1378
         },
         "23CM" : {
            "import_only" : 0,
            "lower" : 1240,
            "upper" : 1300
         },
         "2M" : {
            "import_only" : 0,
            "lower" : 144,
            "upper" : 148
         },
         "2MM" : {
            "import_only" : 0,
            "lower" : 134000,
            "upper" : 149000
         },
         "30M" : {
            "import_only" : 0,
            "lower" : 10.1,
            "upper" : 10.15
         },
         "33CM" : {
            "import_only" : 0,
            "lower" : 902,
            "upper" : 928
         },
         "3CM" : {
            "import_only" : 0,
            "lower" : 10000,
            "upper" : 10500
         },
         "40M" : {
            "import_only" : 0,
            "lower" : 7,
            "upper" : 7.3
         },
         "4M" : {
            "import_only" : 0,
            "lower" : 70,
            "upper" : 71
         },
         "4MM" : {
            "import_only" : 0,
            "lower" : 75500,
            "upper" : 81000
         },
         "560M" : {
            "import_only" : 0,
            "lower" : 0.501,
            "upper" : 0.504
         },
         "5M" : {
            "import_only" : 0,
            "lower" : 54.000001,
            "upper" : 69.9
         },
         "60M" : {
            "import_only" : 0,
            "lower" : 5.06,
            "upper" : 5.45
         },
         "630M" : {
            "import_only" : 0,
            "lower" : 0.472,
            "upper" : 0.479
         },
         "6CM" : {
            "import_only" : 0,
            "lower" : 5650,
            "upper" : 5925
         },
         "6M" : {
            "import_only" : 0,
            "lower" : 50,
            "upper" : 54
         },
         "6MM" : {
            "import_only" : 0,
            "lower" : 47000,
            "upper" : 47200
         },
         "70CM" : {
            "import_only" : 0,
            "lower" : 420,
            "upper" : 450
         },
         "80M" : {
            "import_only" : 0,
            "lower" : 3.5,
            "upper" : 4
         },
         "8M" : {
            "import_only" : 0,
            "lower" : 40,
            "upper" : 45
         },
         "9CM" : {
            "import_only" : 0,
            "lower" : 3300,
            "upper" : 3500
         },
         "SUBMM" : {
            "import_only" : 0,
            "lower" : 300000,
            "upper" : 7500000
         }
      },
      "CONTESTID" : {
         "070-160M-SPRINT" : {
            "import_only" : 0
         },
         "070-3-DAY" : {
            "import_only" : 0
         },
         "070-31-FLAVORS" : {
            "import_only" : 0
         },
         "070-40M-SPRINT" : {
            "import_only" : 0
         },
         "070-80M-SPRINT" : {
            "import_only" : 0
         },
         "070-PSKFEST" : {
            "import_only" : 0
         },
         "070-ST-PATS-DAY" : {
            "import_only" : 0
         },
         "070-VALENTINE-SPRINT" : {
            "import_only" : 0
         },
         "10-RTTY" : {
            "import_only" : 0
         },
         "1010-OPEN-SEASON" : {
            "import_only" : 0
         },
         "7QP" : {
            "import_only" : 0
         },
         "AL-QSO-PARTY" : {
            "import_only" : 0
         },
         "ALL-ASIAN-DX-CW" : {
            "import_only" : 0
         },
         "ALL-ASIAN-DX-PHONE" : {
            "import_only" : 0
         },
         "ANARTS-RTTY" : {
            "import_only" : 0
         },
         "ANATOLIAN-RTTY" : {
            "import_only" : 0
         },
         "AP-SPRINT" : {
            "import_only" : 0
         },
         "AR-QSO-PARTY" : {
            "import_only" : 0
         },
         "ARI-DX" : {
            "import_only" : 0
         },
         "ARI-EME" : {
            "import_only" : 0
         },
         "ARI-IAC-13CM" : {
            "import_only" : 0
         },
         "ARI-IAC-23CM" : {
            "import_only" : 0
         },
         "ARI-IAC-6M" : {
            "import_only" : 0
         },
         "ARI-IAC-UHF" : {
            "import_only" : 0
         },
         "ARI-IAC-VHF" : {
            "import_only" : 0
         },
         "ARRL-10" : {
            "import_only" : 0
         },
         "ARRL-10-GHZ" : {
            "import_only" : 0
         },
         "ARRL-160" : {
            "import_only" : 0
         },
         "ARRL-222" : {
            "import_only" : 0
         },
         "ARRL-DIGI" : {
            "import_only" : 0
         },
         "ARRL-DX-CW" : {
            "import_only" : 0
         },
         "ARRL-DX-SSB" : {
            "import_only" : 0
         },
         "ARRL-EME" : {
            "import_only" : 0
         },
         "ARRL-FIELD-DAY" : {
            "import_only" : 0
         },
         "ARRL-RR-CW" : {
            "import_only" : 0
         },
         "ARRL-RR-RTTY" : {
            "import_only" : 0
         },
         "ARRL-RR-SSB" : {
            "import_only" : 0
         },
         "ARRL-RTTY" : {
            "import_only" : 0
         },
         "ARRL-SCR" : {
            "import_only" : 0
         },
         "ARRL-SS-CW" : {
            "import_only" : 0
         },
         "ARRL-SS-SSB" : {
            "import_only" : 0
         },
         "ARRL-UHF-AUG" : {
            "import_only" : 0
         },
         "ARRL-VHF-JAN" : {
            "import_only" : 0
         },
         "ARRL-VHF-JUN" : {
            "import_only" : 0
         },
         "ARRL-VHF-SEP" : {
            "import_only" : 0
         },
         "AZ-QSO-PARTY" : {
            "import_only" : 0
         },
         "BANGGAI-DX" : {
            "import_only" : 0
         },
         "BARTG-RTTY" : {
            "import_only" : 0
         },
         "BARTG-SPRINT" : {
            "import_only" : 0
         },
         "BC-QSO-PARTY" : {
            "import_only" : 0
         },
         "BEKASI-MERDEKA-CONTEST" : {
            "import_only" : 0
         },
         "CA-QSO-PARTY" : {
            "import_only" : 0
         },
         "CIS-DX" : {
            "import_only" : 0
         },
         "CO-QSO-PARTY" : {
            "import_only" : 0
         },
         "CQ-160-CW" : {
            "import_only" : 0
         },
         "CQ-160-SSB" : {
            "import_only" : 0
         },
         "CQ-M" : {
            "import_only" : 0
         },
         "CQ-VHF" : {
            "import_only" : 0
         },
         "CQ-WPX-CW" : {
            "import_only" : 0
         },
         "CQ-WPX-RTTY" : {
            "import_only" : 0
         },
         "CQ-WPX-SSB" : {
            "import_only" : 0
         },
         "CQ-WW-CW" : {
            "import_only" : 0
         },
         "CQ-WW-RTTY" : {
            "import_only" : 0
         },
         "CQ-WW-SSB" : {
            "import_only" : 0
         },
         "CT-QSO-PARTY" : {
            "import_only" : 0
         },
         "CVA-DX-CW" : {
            "import_only" : 0
         },
         "CVA-DX-SSB" : {
            "import_only" : 0
         },
         "CWOPS-CW-OPEN" : {
            "import_only" : 0
         },
         "CWOPS-CWT" : {
            "import_only" : 0
         },
         "DARC-10" : {
            "import_only" : 0
         },
         "DARC-CWA" : {
            "import_only" : 0
         },
         "DARC-FT4" : {
            "import_only" : 0
         },
         "DARC-HELL" : {
            "import_only" : 0
         },
         "DARC-MICROWAVE" : {
            "import_only" : 0
         },
         "DARC-TRAINEE" : {
            "import_only" : 0
         },
         "DARC-UKW-FIELD-DAY" : {
            "import_only" : 0
         },
         "DARC-UKW-SPRING" : {
            "import_only" : 0
         },
         "DARC-VHF-UHF-MICROWAVE" : {
            "import_only" : 0
         },
         "DARC-WAEDC-CW" : {
            "import_only" : 0
         },
         "DARC-WAEDC-RTTY" : {
            "import_only" : 0
         },
         "DARC-WAEDC-SSB" : {
            "import_only" : 0
         },
         "DARC-WAG" : {
            "import_only" : 0
         },
         "DE-QSO-PARTY" : {
            "import_only" : 0
         },
         "DL-DX-RTTY" : {
            "import_only" : 0
         },
         "DMC-RTTY" : {
            "import_only" : 0
         },
         "EA-CNCW" : {
            "import_only" : 0
         },
         "EA-DME" : {
            "import_only" : 0
         },
         "EA-MAJESTAD-CW" : {
            "import_only" : 0
         },
         "EA-MAJESTAD-SSB" : {
            "import_only" : 0
         },
         "EA-PSK63" : {
            "import_only" : 0
         },
         "EA-RTTY" : {
            "import_only" : 1
         },
         "EA-SMRE-CW" : {
            "import_only" : 0
         },
         "EA-SMRE-SSB" : {
            "import_only" : 0
         },
         "EA-VHF-ATLANTIC" : {
            "import_only" : 0
         },
         "EA-VHF-COM" : {
            "import_only" : 0
         },
         "EA-VHF-COSTA-SOL" : {
            "import_only" : 0
         },
         "EA-VHF-EA" : {
            "import_only" : 0
         },
         "EA-VHF-EA1RCS" : {
            "import_only" : 0
         },
         "EA-VHF-QSL" : {
            "import_only" : 0
         },
         "EA-VHF-SADURNI" : {
            "import_only" : 0
         },
         "EA-WW-RTTY" : {
            "import_only" : 0
         },
         "EASTER" : {
            "import_only" : 0
         },
         "EPC-PSK63" : {
            "import_only" : 0
         },
         "EU SPRINT" : {
            "import_only" : 0
         },
         "EU-HF" : {
            "import_only" : 0
         },
         "EU-PSK-DX" : {
            "import_only" : 0
         },
         "EUCW160M" : {
            "import_only" : 0
         },
         "FALL SPRINT" : {
            "import_only" : 0
         },
         "FL-QSO-PARTY" : {
            "import_only" : 0
         },
         "GA-QSO-PARTY" : {
            "import_only" : 0
         },
         "HA-DX" : {
            "import_only" : 0
         },
         "HELVETIA" : {
            "import_only" : 0
         },
         "HI-QSO-PARTY" : {
            "import_only" : 0
         },
         "HOLYLAND" : {
            "import_only" : 0
         },
         "IA-QSO-PARTY" : {
            "import_only" : 0
         },
         "IARU-FIELD-DAY" : {
            "import_only" : 0
         },
         "IARU-HF" : {
            "import_only" : 0
         },
         "ICWC-MST" : {
            "import_only" : 0
         },
         "ID-QSO-PARTY" : {
            "import_only" : 0
         },
         "IL QSO PARTY" : {
            "import_only" : 0
         },
         "IN-QSO-PARTY" : {
            "import_only" : 0
         },
         "JARTS-WW-RTTY" : {
            "import_only" : 0
         },
         "JIDX-CW" : {
            "import_only" : 0
         },
         "JIDX-SSB" : {
            "import_only" : 0
         },
         "JT-DX-RTTY" : {
            "import_only" : 0
         },
         "K1USN-SSO" : {
            "import_only" : 0
         },
         "K1USN-SST" : {
            "import_only" : 0
         },
         "KS-QSO-PARTY" : {
            "import_only" : 0
         },
         "KY-QSO-PARTY" : {
            "import_only" : 0
         },
         "LA-QSO-PARTY" : {
            "import_only" : 0
         },
         "LDC-RTTY" : {
            "import_only" : 0
         },
         "LZ DX" : {
            "import_only" : 0
         },
         "MAR-QSO-PARTY" : {
            "import_only" : 0
         },
         "MD-QSO-PARTY" : {
            "import_only" : 0
         },
         "ME-QSO-PARTY" : {
            "import_only" : 0
         },
         "MI-QSO-PARTY" : {
            "import_only" : 0
         },
         "MIDATLANTIC-QSO-PARTY" : {
            "import_only" : 0
         },
         "MN-QSO-PARTY" : {
            "import_only" : 0
         },
         "MO-QSO-PARTY" : {
            "import_only" : 0
         },
         "MS-QSO-PARTY" : {
            "import_only" : 0
         },
         "MT-QSO-PARTY" : {
            "import_only" : 0
         },
         "NA-SPRINT-CW" : {
            "import_only" : 0
         },
         "NA-SPRINT-RTTY" : {
            "import_only" : 0
         },
         "NA-SPRINT-SSB" : {
            "import_only" : 0
         },
         "NAQP-CW" : {
            "import_only" : 0
         },
         "NAQP-RTTY" : {
            "import_only" : 0
         },
         "NAQP-SSB" : {
            "import_only" : 0
         },
         "NAVAL" : {
            "import_only" : 0
         },
         "NC-QSO-PARTY" : {
            "import_only" : 0
         },
         "ND-QSO-PARTY" : {
            "import_only" : 0
         },
         "NE-QSO-PARTY" : {
            "import_only" : 0
         },
         "NEQP" : {
            "import_only" : 0
         },
         "NH-QSO-PARTY" : {
            "import_only" : 0
         },
         "NJ-QSO-PARTY" : {
            "import_only" : 0
         },
         "NM-QSO-PARTY" : {
            "import_only" : 0
         },
         "NRAU-BALTIC-CW" : {
            "import_only" : 0
         },
         "NRAU-BALTIC-SSB" : {
            "import_only" : 0
         },
         "NV-QSO-PARTY" : {
            "import_only" : 0
         },
         "NY-QSO-PARTY" : {
            "import_only" : 0
         },
         "OCEANIA-DX-CW" : {
            "import_only" : 0
         },
         "OCEANIA-DX-SSB" : {
            "import_only" : 0
         },
         "OH-QSO-PARTY" : {
            "import_only" : 0
         },
         "OK-DX-RTTY" : {
            "import_only" : 0
         },
         "OK-OM-DX" : {
            "import_only" : 0
         },
         "OK-QSO-PARTY" : {
            "import_only" : 0
         },
         "OMISS-QSO-PARTY" : {
            "import_only" : 0
         },
         "ON-QSO-PARTY" : {
            "import_only" : 0
         },
         "OR-QSO-PARTY" : {
            "import_only" : 0
         },
         "ORARI-DX" : {
            "import_only" : 0
         },
         "PA-QSO-PARTY" : {
            "import_only" : 0
         },
         "PACC" : {
            "import_only" : 0
         },
         "PCC" : {
            "import_only" : 0
         },
         "PSK-DEATHMATCH" : {
            "import_only" : 0
         },
         "QC-QSO-PARTY" : {
            "import_only" : 0
         },
         "RAC" : {
            "import_only" : 1
         },
         "RAC-CANADA-DAY" : {
            "import_only" : 0
         },
         "RAC-CANADA-WINTER" : {
            "import_only" : 0
         },
         "RDAC" : {
            "import_only" : 0
         },
         "RDXC" : {
            "import_only" : 0
         },
         "REF-160M" : {
            "import_only" : 0
         },
         "REF-CW" : {
            "import_only" : 0
         },
         "REF-SSB" : {
            "import_only" : 0
         },
         "REP-PORTUGAL-DAY-HF" : {
            "import_only" : 0
         },
         "RI-QSO-PARTY" : {
            "import_only" : 0
         },
         "RSGB-160" : {
            "import_only" : 0
         },
         "RSGB-21/28-CW" : {
            "import_only" : 0
         },
         "RSGB-21/28-SSB" : {
            "import_only" : 0
         },
         "RSGB-80M-CC" : {
            "import_only" : 0
         },
         "RSGB-AFS-CW" : {
            "import_only" : 0
         },
         "RSGB-AFS-SSB" : {
            "import_only" : 0
         },
         "RSGB-CLUB-CALLS" : {
            "import_only" : 0
         },
         "RSGB-COMMONWEALTH" : {
            "import_only" : 0
         },
         "RSGB-IOTA" : {
            "import_only" : 0
         },
         "RSGB-LOW-POWER" : {
            "import_only" : 0
         },
         "RSGB-NFD" : {
            "import_only" : 0
         },
         "RSGB-ROPOCO" : {
            "import_only" : 0
         },
         "RSGB-SSB-FD" : {
            "import_only" : 0
         },
         "RUSSIAN-RTTY" : {
            "import_only" : 0
         },
         "SAC-CW" : {
            "import_only" : 0
         },
         "SAC-SSB" : {
            "import_only" : 0
         },
         "SARTG-RTTY" : {
            "import_only" : 0
         },
         "SC-QSO-PARTY" : {
            "import_only" : 0
         },
         "SCC-RTTY" : {
            "import_only" : 0
         },
         "SD-QSO-PARTY" : {
            "import_only" : 0
         },
         "SHORTRY" : {
            "import_only" : 0
         },
         "SKCC-SKS" : {
            "import_only" : 0
         },
         "SKCC-SKSA" : {
            "import_only" : 0
         },
         "SKCC-SKSE" : {
            "import_only" : 0
         },
         "SKCC-WES" : {
            "import_only" : 0
         },
         "SMP-AUG" : {
            "import_only" : 0
         },
         "SMP-MAY" : {
            "import_only" : 0
         },
         "SP-DX-RTTY" : {
            "import_only" : 0
         },
         "SPAR-WINTER-FD" : {
            "import_only" : 0
         },
         "SPDXCONTEST" : {
            "import_only" : 0
         },
         "SPRING SPRINT" : {
            "import_only" : 0
         },
         "SR-MARATHON" : {
            "import_only" : 0
         },
         "STEW-PERRY" : {
            "import_only" : 0
         },
         "SUMMER SPRINT" : {
            "import_only" : 0
         },
         "TARA-GRID-DIP" : {
            "import_only" : 0
         },
         "TARA-RTTY" : {
            "import_only" : 0
         },
         "TARA-RUMBLE" : {
            "import_only" : 0
         },
         "TARA-SKIRMISH" : {
            "import_only" : 0
         },
         "TEN-RTTY" : {
            "import_only" : 0
         },
         "TMC-RTTY" : {
            "import_only" : 0
         },
         "TN-QSO-PARTY" : {
            "import_only" : 0
         },
         "TX-QSO-PARTY" : {
            "import_only" : 0
         },
         "UBA-DX-CW" : {
            "import_only" : 0
         },
         "UBA-DX-SSB" : {
            "import_only" : 0
         },
         "UK-DX-BPSK63" : {
            "import_only" : 0
         },
         "UK-DX-RTTY" : {
            "import_only" : 0
         },
         "UKR-CHAMP-RTTY" : {
            "import_only" : 0
         },
         "UKRAINIAN DX" : {
            "import_only" : 0
         },
         "UKSMG-6M-MARATHON" : {
            "import_only" : 0
         },
         "UKSMG-SUMMER-ES" : {
            "import_only" : 0
         },
         "URE-DX" : {
            "import_only" : 1
         },
         "US-COUNTIES-QSO" : {
            "import_only" : 0
         },
         "UT-QSO-PARTY" : {
            "import_only" : 0
         },
         "VA-QSO-PARTY" : {
            "import_only" : 0
         },
         "VENEZ-IND-DAY" : {
            "import_only" : 0
         },
         "VIRGINIA QSO PARTY" : {
            "import_only" : 1
         },
         "VOLTA-RTTY" : {
            "import_only" : 0
         },
         "VT-QSO-PARTY" : {
            "import_only" : 0
         },
         "WA-QSO-PARTY" : {
            "import_only" : 0
         },
         "WFD" : {
            "import_only" : 0
         },
         "WI-QSO-PARTY" : {
            "import_only" : 0
         },
         "WIA-HARRY ANGEL" : {
            "import_only" : 0
         },
         "WIA-JMMFD" : {
            "import_only" : 0
         },
         "WIA-OCDX" : {
            "import_only" : 0
         },
         "WIA-REMEMBRANCE" : {
            "import_only" : 0
         },
         "WIA-ROSS HULL" : {
            "import_only" : 0
         },
         "WIA-TRANS TASMAN" : {
            "import_only" : 0
         },
         "WIA-VHF/UHF FD" : {
            "import_only" : 0
         },
         "WIA-VK SHIRES" : {
            "import_only" : 0
         },
         "WINTER SPRINT" : {
            "import_only" : 0
         },
         "WV-QSO-PARTY" : {
            "import_only" : 0
         },
         "WW-DIGI" : {
            "import_only" : 0
         },
         "WY-QSO-PARTY" : {
            "import_only" : 0
         },
         "XE-INTL-RTTY" : {
            "import_only" : 0
         },
         "YOHFDX" : {
            "import_only" : 0
         },
         "YUDXC" : {
            "import_only" : 0
         }
      },
      "CONTINENT" : {
         "AF" : {
            "import_only" : 0
         },
         "AN" : {
            "import_only" : 0
         },
         "AS" : {
            "import_only" : 0
         },
         "EU" : {
            "import_only" : 0
         },
         "NA" : {
            "import_only" : 0
         },
         "OC" : {
            "import_only" : 0
         },
         "SA" : {
            "import_only" : 0
         }
      },
      "CREDIT" : {
         "CQDX" : {
            "import_only" : 0
         },
         "CQDXFIELD" : {
            "import_only" : 0
         },
         "CQDXFIELD_BAND" : {
            "import_only" : 0
         },
         "CQDXFIELD_MOBILE" : {
            "import_only" : 0
         },
         "CQDXFIELD_MODE" : {
            "import_only" : 0
         },
         "CQDXFIELD_QRP" : {
            "import_only" : 0
         },
         "CQDXFIELD_SATELLITE" : {
            "import_only" : 0
         },
         "CQDX_BAND" : {
            "import_only" : 0
         },
         "CQDX_MOBILE" : {
            "import_only" : 0
         },
         "CQDX_MODE" : {
            "import_only" : 0
         },
         "CQDX_QRP" : {
            "import_only" : 0
         },
         "CQDX_SATELLITE" : {
            "import_only" : 0
         },
         "CQWAZ_BAND" : {
            "import_only" : 0
         },
         "CQWAZ_EME" : {
            "import_only" : 0
         },
         "CQWAZ_MIXED" : {
            "import_only" : 0
         },
         "CQWAZ_MOBILE" : {
            "import_only" : 0
         },
         "CQWAZ_MODE" : {
            "import_only" : 0
         },
         "CQWAZ_QRP" : {
            "import_only" : 0
         },
         "CQWAZ_SATELLITE" : {
            "import_only" : 0
         },
         "CQWPX" : {
            "import_only" : 0
         },
         "CQWPX_BAND" : {
            "import_only" : 0
         },
         "CQWPX_MODE" : {
            "import_only" : 0
         },
         "CREDIT FOR" : {
            "import_only" : 0
         },
         "DXCC" : {
            "import_only" : 0
         },
         "DXCC_BAND" : {
            "import_only" : 0
         },
         "DXCC_MODE" : {
            "import_only" : 0
         },
         "DXCC_SATELLITE" : {
            "import_only" : 0
         },
         "EAUSTRALIA" : {
            "import_only" : 0
         },
         "ECANADA" : {
            "import_only" : 0
         },
         "ECOUNTY_STATE" : {
            "import_only" : 0
         },
         "EDX" : {
            "import_only" : 0
         },
         "EDX100" : {
            "import_only" : 0
         },
         "EDX100_BAND" : {
            "import_only" : 0
         },
         "EDX100_MODE" : {
            "import_only" : 0
         },
         "EECHOLINK50" : {
            "import_only" : 0
         },
         "EGRID_BAND" : {
            "import_only" : 0
         },
         "EGRID_SATELLITE" : {
            "import_only" : 0
         },
         "EPFX300" : {
            "import_only" : 0
         },
         "EPFX300_MODE" : {
            "import_only" : 0
         },
         "EWAS" : {
            "import_only" : 0
         },
         "EWAS_BAND" : {
            "import_only" : 0
         },
         "EWAS_MODE" : {
            "import_only" : 0
         },
         "EWAS_SATELLITE" : {
            "import_only" : 0
         },
         "EZ40" : {
            "import_only" : 0
         },
         "EZ40_MODE" : {
            "import_only" : 0
         },
         "FFMA" : {
            "import_only" : 0
         },
         "IOTA" : {
            "import_only" : 0
         },
         "IOTA_BASIC" : {
            "import_only" : 0
         },
         "IOTA_CONT" : {
            "import_only" : 0
         },
         "IOTA_GROUP" : {
            "import_only" : 0
         },
         "RDA" : {
            "import_only" : 0
         },
         "USACA" : {
            "import_only" : 0
         },
         "VUCC_BAND" : {
            "import_only" : 0
         },
         "VUCC_SATELLITE" : {
            "import_only" : 0
         },
         "WAB" : {
            "import_only" : 0
         },
         "WAC" : {
            "import_only" : 0
         },
         "WAC_BAND" : {
            "import_only" : 0
         },
         "WAE" : {
            "import_only" : 0
         },
         "WAE_BAND" : {
            "import_only" : 0
         },
         "WAE_MODE" : {
            "import_only" : 0
         },
         "WAIP" : {
            "import_only" : 0
         },
         "WAIP_BAND" : {
            "import_only" : 0
         },
         "WAIP_MODE" : {
            "import_only" : 0
         },
         "WAS" : {
            "import_only" : 0
         },
         "WAS_BAND" : {
            "import_only" : 0
         },
         "WAS_EME" : {
            "import_only" : 0
         },
         "WAS_MODE" : {
            "import_only" : 0
         },
         "WAS_NOVICE" : {
            "import_only" : 0
         },
         "WAS_QRP" : {
            "import_only" : 0
         },
         "WAS_SATELLITE" : {
            "import_only" : 0
         },
         "WITUZ" : {
            "import_only" : 0
         },
         "WITUZ_BAND" : {
            "import_only" : 0
         }
      },
      "DXCCENTITYCODE" : {
         "0" : {
            "import_only" : 0
         },
         "1" : {
            "import_only" : 0
         },
         "10" : {
            "import_only" : 0
         },
         "100" : {
            "import_only" : 0
         },
         "101" : {
            "import_only" : 0
         },
         "102" : {
            "import_only" : 0
         },
         "103" : {
            "import_only" : 0
         },
         "104" : {
            "import_only" : 0
         },
         "105" : {
            "import_only" : 0
         },
         "106" : {
            "import_only" : 0
         },
         "107" : {
            "import_only" : 0
         },
         "108" : {
            "import_only" : 0
         },
         "109" : {
            "import_only" : 0
         },
         "11" : {
            "import_only" : 0
         },
         "110" : {
            "import_only" : 0
         },
         "111" : {
            "import_only" : 0
         },
         "112" : {
            "import_only" : 0
         },
         "113" : {
            "import_only" : 0
         },
         "114" : {
            "import_only" : 0
         },
         "115" : {
            "import_only" : 0
         },
         "116" : {
            "import_only" : 0
         },
         "117" : {
            "import_only" : 0
         },
         "118" : {
            "import_only" : 0
         },
         "119" : {
            "import_only" : 0
         },
         "12" : {
            "import_only" : 0
         },
         "120" : {
            "import_only" : 0
         },
         "122" : {
            "import_only" : 0
         },
         "123" : {
            "import_only" : 0
         },
         "124" : {
            "import_only" : 0
         },
         "125" : {
            "import_only" : 0
         },
         "126" : {
            "import_only" : 0
         },
         "127" : {
            "import_only" : 0
         },
         "128" : {
            "import_only" : 0
         },
         "129" : {
            "import_only" : 0
         },
         "13" : {
            "import_only" : 0
         },
         "130" : {
            "import_only" : 0
         },
         "131" : {
            "import_only" : 0
         },
         "132" : {
            "import_only" : 0
         },
         "133" : {
            "import_only" : 0
         },
         "134" : {
            "import_only" : 0
         },
         "135" : {
            "import_only" : 0
         },
         "136" : {
            "import_only" : 0
         },
         "137" : {
            "import_only" : 0
         },
         "138" : {
            "import_only" : 0
         },
         "139" : {
            "import_only" : 0
         },
         "14" : {
            "import_only" : 0
         },
         "140" : {
            "import_only" : 0
         },
         "141" : {
            "import_only" : 0
         },
         "142" : {
            "import_only" : 0
         },
         "143" : {
            "import_only" : 0
         },
         "144" : {
            "import_only" : 0
         },
         "145" : {
            "import_only" : 0
         },
         "146" : {
            "import_only" : 0
         },
         "147" : {
            "import_only" : 0
         },
         "148" : {
            "import_only" : 0
         },
         "149" : {
            "import_only" : 0
         },
         "15" : {
            "import_only" : 0
         },
         "150" : {
            "import_only" : 0
         },
         "151" : {
            "import_only" : 0
         },
         "152" : {
            "import_only" : 0
         },
         "153" : {
            "import_only" : 0
         },
         "154" : {
            "import_only" : 0
         },
         "155" : {
            "import_only" : 0
         },
         "157" : {
            "import_only" : 0
         },
         "158" : {
            "import_only" : 0
         },
         "159" : {
            "import_only" : 0
         },
         "16" : {
            "import_only" : 0
         },
         "160" : {
            "import_only" : 0
         },
         "161" : {
            "import_only" : 0
         },
         "162" : {
            "import_only" : 0
         },
         "163" : {
            "import_only" : 0
         },
         "164" : {
            "import_only" : 0
         },
         "165" : {
            "import_only" : 0
         },
         "166" : {
            "import_only" : 0
         },
         "167" : {
            "import_only" : 0
         },
         "168" : {
            "import_only" : 0
         },
         "169" : {
            "import_only" : 0
         },
         "17" : {
            "import_only" : 0
         },
         "170" : {
            "import_only" : 0
         },
         "171" : {
            "import_only" : 0
         },
         "172" : {
            "import_only" : 0
         },
         "173" : {
            "import_only" : 0
         },
         "174" : {
            "import_only" : 0
         },
         "175" : {
            "import_only" : 0
         },
         "176" : {
            "import_only" : 0
         },
         "177" : {
            "import_only" : 0
         },
         "178" : {
            "import_only" : 0
         },
         "179" : {
            "import_only" : 0
         },
         "18" : {
            "import_only" : 0
         },
         "180" : {
            "import_only" : 0
         },
         "181" : {
            "import_only" : 0
         },
         "182" : {
            "import_only" : 0
         },
         "183" : {
            "import_only" : 0
         },
         "184" : {
            "import_only" : 0
         },
         "185" : {
            "import_only" : 0
         },
         "186" : {
            "import_only" : 0
         },
         "187" : {
            "import_only" : 0
         },
         "188" : {
            "import_only" : 0
         },
         "189" : {
            "import_only" : 0
         },
         "19" : {
            "import_only" : 0
         },
         "190" : {
            "import_only" : 0
         },
         "191" : {
            "import_only" : 0
         },
         "192" : {
            "import_only" : 0
         },
         "193" : {
            "import_only" : 0
         },
         "194" : {
            "import_only" : 0
         },
         "195" : {
            "import_only" : 0
         },
         "196" : {
            "import_only" : 0
         },
         "197" : {
            "import_only" : 0
         },
         "198" : {
            "import_only" : 0
         },
         "199" : {
            "import_only" : 0
         },
         "2" : {
            "import_only" : 0
         },
         "20" : {
            "import_only" : 0
         },
         "200" : {
            "import_only" : 0
         },
         "201" : {
            "import_only" : 0
         },
         "202" : {
            "import_only" : 0
         },
         "203" : {
            "import_only" : 0
         },
         "204" : {
            "import_only" : 0
         },
         "205" : {
            "import_only" : 0
         },
         "206" : {
            "import_only" : 0
         },
         "207" : {
            "import_only" : 0
         },
         "208" : {
            "import_only" : 0
         },
         "209" : {
            "import_only" : 0
         },
         "21" : {
            "import_only" : 0
         },
         "210" : {
            "import_only" : 0
         },
         "211" : {
            "import_only" : 0
         },
         "212" : {
            "import_only" : 0
         },
         "213" : {
            "import_only" : 0
         },
         "214" : {
            "import_only" : 0
         },
         "215" : {
            "import_only" : 0
         },
         "216" : {
            "import_only" : 0
         },
         "217" : {
            "import_only" : 0
         },
         "218" : {
            "import_only" : 0
         },
         "219" : {
            "import_only" : 0
         },
         "22" : {
            "import_only" : 0
         },
         "220" : {
            "import_only" : 0
         },
         "221" : {
            "import_only" : 0
         },
         "222" : {
            "import_only" : 0
         },
         "223" : {
            "import_only" : 0
         },
         "224" : {
            "import_only" : 0
         },
         "225" : {
            "import_only" : 0
         },
         "226" : {
            "import_only" : 0
         },
         "227" : {
            "import_only" : 0
         },
         "228" : {
            "import_only" : 0
         },
         "229" : {
            "import_only" : 0
         },
         "23" : {
            "import_only" : 0
         },
         "230" : {
            "import_only" : 0
         },
         "231" : {
            "import_only" : 0
         },
         "232" : {
            "import_only" : 0
         },
         "233" : {
            "import_only" : 0
         },
         "234" : {
            "import_only" : 0
         },
         "235" : {
            "import_only" : 0
         },
         "236" : {
            "import_only" : 0
         },
         "237" : {
            "import_only" : 0
         },
         "238" : {
            "import_only" : 0
         },
         "239" : {
            "import_only" : 0
         },
         "24" : {
            "import_only" : 0
         },
         "240" : {
            "import_only" : 0
         },
         "241" : {
            "import_only" : 0
         },
         "242" : {
            "import_only" : 0
         },
         "243" : {
            "import_only" : 0
         },
         "244" : {
            "import_only" : 0
         },
         "245" : {
            "import_only" : 0
         },
         "246" : {
            "import_only" : 0
         },
         "247" : {
            "import_only" : 0
         },
         "248" : {
            "import_only" : 0
         },
         "249" : {
            "import_only" : 0
         },
         "25" : {
            "import_only" : 0
         },
         "250" : {
            "import_only" : 0
         },
         "251" : {
            "import_only" : 0
         },
         "252" : {
            "import_only" : 0
         },
         "253" : {
            "import_only" : 0
         },
         "254" : {
            "import_only" : 0
         },
         "255" : {
            "import_only" : 0
         },
         "256" : {
            "import_only" : 0
         },
         "257" : {
            "import_only" : 0
         },
         "258" : {
            "import_only" : 0
         },
         "259" : {
            "import_only" : 0
         },
         "26" : {
            "import_only" : 0
         },
         "260" : {
            "import_only" : 0
         },
         "261" : {
            "import_only" : 0
         },
         "262" : {
            "import_only" : 0
         },
         "263" : {
            "import_only" : 0
         },
         "264" : {
            "import_only" : 0
         },
         "265" : {
            "import_only" : 0
         },
         "266" : {
            "import_only" : 0
         },
         "267" : {
            "import_only" : 0
         },
         "268" : {
            "import_only" : 0
         },
         "269" : {
            "import_only" : 0
         },
         "27" : {
            "import_only" : 0
         },
         "270" : {
            "import_only" : 0
         },
         "271" : {
            "import_only" : 0
         },
         "272" : {
            "import_only" : 0
         },
         "273" : {
            "import_only" : 0
         },
         "274" : {
            "import_only" : 0
         },
         "275" : {
            "import_only" : 0
         },
         "276" : {
            "import_only" : 0
         },
         "277" : {
            "import_only" : 0
         },
         "278" : {
            "import_only" : 0
         },
         "279" : {
            "import_only" : 0
         },
         "28" : {
            "import_only" : 0
         },
         "280" : {
            "import_only" : 0
         },
         "281" : {
            "import_only" : 0
         },
         "282" : {
            "import_only" : 0
         },
         "283" : {
            "import_only" : 0
         },
         "284" : {
            "import_only" : 0
         },
         "285" : {
            "import_only" : 0
         },
         "286" : {
            "import_only" : 0
         },
         "287" : {
            "import_only" : 0
         },
         "288" : {
            "import_only" : 0
         },
         "289" : {
            "import_only" : 0
         },
         "29" : {
            "import_only" : 0
         },
         "291" : {
            "import_only" : 0
         },
         "292" : {
            "import_only" : 0
         },
         "293" : {
            "import_only" : 0
         },
         "294" : {
            "import_only" : 0
         },
         "295" : {
            "import_only" : 0
         },
         "296" : {
            "import_only" : 0
         },
         "297" : {
            "import_only" : 0
         },
         "298" : {
            "import_only" : 0
         },
         "299" : {
            "import_only" : 0
         },
         "3" : {
            "import_only" : 0
         },
         "30" : {
            "import_only" : 0
         },
         "301" : {
            "import_only" : 0
         },
         "302" : {
            "import_only" : 0
         },
         "303" : {
            "import_only" : 0
         },
         "304" : {
            "import_only" : 0
         },
         "305" : {
            "import_only" : 0
         },
         "306" : {
            "import_only" : 0
         },
         "307" : {
            "import_only" : 0
         },
         "308" : {
            "import_only" : 0
         },
         "309" : {
            "import_only" : 0
         },
         "31" : {
            "import_only" : 0
         },
         "312" : {
            "import_only" : 0
         },
         "315" : {
            "import_only" : 0
         },
         "318" : {
            "import_only" : 0
         },
         "32" : {
            "import_only" : 0
         },
         "321" : {
            "import_only" : 0
         },
         "324" : {
            "import_only" : 0
         },
         "327" : {
            "import_only" : 0
         },
         "33" : {
            "import_only" : 0
         },
         "330" : {
            "import_only" : 0
         },
         "333" : {
            "import_only" : 0
         },
         "336" : {
            "import_only" : 0
         },
         "339" : {
            "import_only" : 0
         },
         "34" : {
            "import_only" : 0
         },
         "342" : {
            "import_only" : 0
         },
         "344" : {
            "import_only" : 0
         },
         "345" : {
            "import_only" : 0
         },
         "348" : {
            "import_only" : 0
         },
         "35" : {
            "import_only" : 0
         },
         "354" : {
            "import_only" : 0
         },
         "36" : {
            "import_only" : 0
         },
         "363" : {
            "import_only" : 0
         },
         "369" : {
            "import_only" : 0
         },
         "37" : {
            "import_only" : 0
         },
         "370" : {
            "import_only" : 0
         },
         "372" : {
            "import_only" : 0
         },
         "375" : {
            "import_only" : 0
         },
         "376" : {
            "import_only" : 0
         },
         "378" : {
            "import_only" : 0
         },
         "379" : {
            "import_only" : 0
         },
         "38" : {
            "import_only" : 0
         },
         "381" : {
            "import_only" : 0
         },
         "382" : {
            "import_only" : 0
         },
         "384" : {
            "import_only" : 0
         },
         "386" : {
            "import_only" : 0
         },
         "387" : {
            "import_only" : 0
         },
         "39" : {
            "import_only" : 0
         },
         "390" : {
            "import_only" : 0
         },
         "391" : {
            "import_only" : 0
         },
         "4" : {
            "import_only" : 0
         },
         "40" : {
            "import_only" : 0
         },
         "400" : {
            "import_only" : 0
         },
         "401" : {
            "import_only" : 0
         },
         "402" : {
            "import_only" : 0
         },
         "404" : {
            "import_only" : 0
         },
         "406" : {
            "import_only" : 0
         },
         "408" : {
            "import_only" : 0
         },
         "409" : {
            "import_only" : 0
         },
         "41" : {
            "import_only" : 0
         },
         "410" : {
            "import_only" : 0
         },
         "411" : {
            "import_only" : 0
         },
         "412" : {
            "import_only" : 0
         },
         "414" : {
            "import_only" : 0
         },
         "416" : {
            "import_only" : 0
         },
         "42" : {
            "import_only" : 0
         },
         "420" : {
            "import_only" : 0
         },
         "422" : {
            "import_only" : 0
         },
         "424" : {
            "import_only" : 0
         },
         "428" : {
            "import_only" : 0
         },
         "43" : {
            "import_only" : 0
         },
         "430" : {
            "import_only" : 0
         },
         "432" : {
            "import_only" : 0
         },
         "434" : {
            "import_only" : 0
         },
         "436" : {
            "import_only" : 0
         },
         "438" : {
            "import_only" : 0
         },
         "44" : {
            "import_only" : 0
         },
         "440" : {
            "import_only" : 0
         },
         "442" : {
            "import_only" : 0
         },
         "444" : {
            "import_only" : 0
         },
         "446" : {
            "import_only" : 0
         },
         "45" : {
            "import_only" : 0
         },
         "450" : {
            "import_only" : 0
         },
         "452" : {
            "import_only" : 0
         },
         "453" : {
            "import_only" : 0
         },
         "454" : {
            "import_only" : 0
         },
         "456" : {
            "import_only" : 0
         },
         "458" : {
            "import_only" : 0
         },
         "46" : {
            "import_only" : 0
         },
         "460" : {
            "import_only" : 0
         },
         "462" : {
            "import_only" : 0
         },
         "464" : {
            "import_only" : 0
         },
         "466" : {
            "import_only" : 0
         },
         "468" : {
            "import_only" : 0
         },
         "47" : {
            "import_only" : 0
         },
         "470" : {
            "import_only" : 0
         },
         "474" : {
            "import_only" : 0
         },
         "478" : {
            "import_only" : 0
         },
         "48" : {
            "import_only" : 0
         },
         "480" : {
            "import_only" : 0
         },
         "482" : {
            "import_only" : 0
         },
         "483" : {
            "import_only" : 0
         },
         "488" : {
            "import_only" : 0
         },
         "489" : {
            "import_only" : 0
         },
         "49" : {
            "import_only" : 0
         },
         "490" : {
            "import_only" : 0
         },
         "492" : {
            "import_only" : 0
         },
         "493" : {
            "import_only" : 0
         },
         "497" : {
            "import_only" : 0
         },
         "499" : {
            "import_only" : 0
         },
         "5" : {
            "import_only" : 0
         },
         "50" : {
            "import_only" : 0
         },
         "501" : {
            "import_only" : 0
         },
         "502" : {
            "import_only" : 0
         },
         "503" : {
            "import_only" : 0
         },
         "504" : {
            "import_only" : 0
         },
         "505" : {
            "import_only" : 0
         },
         "506" : {
            "import_only" : 0
         },
         "507" : {
            "import_only" : 0
         },
         "508" : {
            "import_only" : 0
         },
         "509" : {
            "import_only" : 0
         },
         "51" : {
            "import_only" : 0
         },
         "510" : {
            "import_only" : 0
         },
         "511" : {
            "import_only" : 0
         },
         "512" : {
            "import_only" : 0
         },
         "513" : {
            "import_only" : 0
         },
         "514" : {
            "import_only" : 0
         },
         "515" : {
            "import_only" : 0
         },
         "516" : {
            "import_only" : 0
         },
         "517" : {
            "import_only" : 0
         },
         "518" : {
            "import_only" : 0
         },
         "519" : {
            "import_only" : 0
         },
         "52" : {
            "import_only" : 0
         },
         "520" : {
            "import_only" : 0
         },
         "521" : {
            "import_only" : 0
         },
         "522" : {
            "import_only" : 0
         },
         "53" : {
            "import_only" : 0
         },
         "54" : {
            "import_only" : 0
         },
         "55" : {
            "import_only" : 0
         },
         "56" : {
            "import_only" : 0
         },
         "57" : {
            "import_only" : 0
         },
         "58" : {
            "import_only" : 0
         },
         "59" : {
            "import_only" : 0
         },
         "6" : {
            "import_only" : 0
         },
         "60" : {
            "import_only" : 0
         },
         "61" : {
            "import_only" : 0
         },
         "62" : {
            "import_only" : 0
         },
         "63" : {
            "import_only" : 0
         },
         "64" : {
            "import_only" : 0
         },
         "65" : {
            "import_only" : 0
         },
         "66" : {
            "import_only" : 0
         },
         "67" : {
            "import_only" : 0
         },
         "68" : {
            "import_only" : 0
         },
         "69" : {
            "import_only" : 0
         },
         "7" : {
            "import_only" : 0
         },
         "70" : {
            "import_only" : 0
         },
         "71" : {
            "import_only" : 0
         },
         "72" : {
            "import_only" : 0
         },
         "74" : {
            "import_only" : 0
         },
         "75" : {
            "import_only" : 0
         },
         "76" : {
            "import_only" : 0
         },
         "77" : {
            "import_only" : 0
         },
         "78" : {
            "import_only" : 0
         },
         "79" : {
            "import_only" : 0
         },
         "8" : {
            "import_only" : 0
         },
         "80" : {
            "import_only" : 0
         },
         "81" : {
            "import_only" : 0
         },
         "82" : {
            "import_only" : 0
         },
         "84" : {
            "import_only" : 0
         },
         "85" : {
            "import_only" : 0
         },
         "86" : {
            "import_only" : 0
         },
         "88" : {
            "import_only" : 0
         },
         "89" : {
            "import_only" : 0
         },
         "9" : {
            "import_only" : 0
         },
         "90" : {
            "import_only" : 0
         },
         "91" : {
            "import_only" : 0
         },
         "93" : {
            "import_only" : 0
         },
         "94" : {
            "import_only" : 0
         },
         "95" : {
            "import_only" : 0
         },
         "96" : {
            "import_only" : 0
         },
         "97" : {
            "import_only" : 0
         },
         "98" : {
            "import_only" : 0
         },
         "99" : {
            "import_only" : 0
         }
      },
      "EQSLAG" : {
         "N" : {
            "import_only" : 0
         },
         "U" : {
            "import_only" : 0
         },
         "Y" : {
            "import_only" : 0
         }
      },
      "MODE" : {
         "AM" : {
            "import_only" : 0
         },
         "AMTORFEC" : {
            "import_only" : 1
         },
         "ARDOP" : {
            "import_only" : 0
         },
         "ASCI" : {
            "import_only" : 1
         },
         "ATV" : {
            "import_only" : 0
         },
         "C4FM" : {
            "import_only" : 1
         },
         "CHIP" : {
            "import_only" : 0
         },
         "CHIP128" : {
            "import_only" : 1
         },
         "CHIP64" : {
            "import_only" : 1
         },
         "CLO" : {
            "import_only" : 0
         },
         "CONTESTI" : {
            "import_only" : 0
         },
         "CW" : {
            "import_only" : 0
         },
         "DIGITALVOICE" : {
            "import_only" : 0
         },
         "DOMINO" : {
            "import_only" : 0
         },
         "DOMINOF" : {
            "import_only" : 1
         },
         "DSTAR" : {
            "import_only" : 1
         },
         "DYNAMIC" : {
            "import_only" : 0
         },
         "FAX" : {
            "import_only" : 0
         },
         "FM" : {
            "import_only" : 0
         },
         "FMHELL" : {
            "import_only" : 1
         },
         "FSK" : {
            "import_only" : 0
         },
         "FSK31" : {
            "import_only" : 1
         },
         "FSK441" : {
            "import_only" : 0
         },
         "FT8" : {
            "import_only" : 0
         },
         "GTOR" : {
            "import_only" : 1
         },
         "HELL" : {
            "import_only" : 0
         },
         "HELL80" : {
            "import_only" : 1
         },
         "HFSK" : {
            "import_only" : 1
         },
         "ISCAT" : {
            "import_only" : 0
         },
         "JT4" : {
            "import_only" : 0
         },
         "JT44" : {
            "import_only" : 0
         },
         "JT4A" : {
            "import_only" : 1
         },
         "JT4B" : {
            "import_only" : 1
         },
         "JT4C" : {
            "import_only" : 1
         },
         "JT4D" : {
            "import_only" : 1
         },
         "JT4E" : {
            "import_only" : 1
         },
         "JT4F" : {
            "import_only" : 1
         },
         "JT4G" : {
            "import_only" : 1
         },
         "JT65" : {
            "import_only" : 0
         },
         "JT65A" : {
            "import_only" : 1
         },
         "JT65B" : {
            "import_only" : 1
         },
         "JT65C" : {
            "import_only" : 1
         },
         "JT6M" : {
            "import_only" : 0
         },
         "JT9" : {
            "import_only" : 0
         },
         "MFSK" : {
            "import_only" : 0
         },
         "MFSK16" : {
            "import_only" : 1
         },
         "MFSK8" : {
            "import_only" : 1
         },
         "MSK144" : {
            "import_only" : 0
         },
         "MT63" : {
            "import_only" : 0
         },
         "MTONE" : {
            "import_only" : 0
         },
         "OFDM" : {
            "import_only" : 0
         },
         "OLIVIA" : {
            "import_only" : 0
         },
         "OPERA" : {
            "import_only" : 0
         },
         "PAC" : {
            "import_only" : 0
         },
         "PAC2" : {
            "import_only" : 1
         },
         "PAC3" : {
            "import_only" : 1
         },
         "PAX" : {
            "import_only" : 0
         },
         "PAX2" : {
            "import_only" : 1
         },
         "PCW" : {
            "import_only" : 1
         },
         "PKT" : {
            "import_only" : 0
         },
         "PSK" : {
            "import_only" : 0
         },
         "PSK10" : {
            "import_only" : 1
         },
         "PSK125" : {
            "import_only" : 1
         },
         "PSK2K" : {
            "import_only" : 0
         },
         "PSK31" : {
            "import_only" : 1
         },
         "PSK63" : {
            "import_only" : 1
         },
         "PSK63F" : {
            "import_only" : 1
         },
         "PSKAM10" : {
            "import_only" : 1
         },
         "PSKAM31" : {
            "import_only" : 1
         },
         "PSKAM50" : {
            "import_only" : 1
         },
         "PSKFEC31" : {
            "import_only" : 1
         },
         "PSKHELL" : {
            "import_only" : 1
         },
         "Q15" : {
            "import_only" : 0
         },
         "QPSK125" : {
            "import_only" : 1
         },
         "QPSK31" : {
            "import_only" : 1
         },
         "QPSK63" : {
            "import_only" : 1
         },
         "QRA64" : {
            "import_only" : 0
         },
         "ROS" : {
            "import_only" : 0
         },
         "RTTY" : {
            "import_only" : 0
         },
         "RTTYM" : {
            "import_only" : 0
         },
         "SSB" : {
            "import_only" : 0
         },
         "SSTV" : {
            "import_only" : 0
         },
         "T10" : {
            "import_only" : 0
         },
         "THOR" : {
            "import_only" : 0
         },
         "THRB" : {
            "import_only" : 0
         },
         "THRBX" : {
            "import_only" : 1
         },
         "TOR" : {
            "import_only" : 0
         },
         "V4" : {
            "import_only" : 0
         },
         "VOI" : {
            "import_only" : 0
         },
         "WINMOR" : {
            "import_only" : 0
         },
         "WSPR" : {
            "import_only" : 0
         }
      },
      "MORSEKEYTYPE" : {
         "BUG" : {
            "import_only" : 0
         },
         "CPU" : {
            "import_only" : 0
         },
         "DP" : {
            "import_only" : 0
         },
         "FAB" : {
            "import_only" : 0
         },
         "SK" : {
            "import_only" : 0
         },
         "SP" : {
            "import_only" : 0
         },
         "SS" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION1" : {
         "AB" : {
            "import_only" : 0
         },
         "BC" : {
            "import_only" : 0
         },
         "MB" : {
            "import_only" : 0
         },
         "NB" : {
            "import_only" : 0
         },
         "NL" : {
            "import_only" : 0
         },
         "NS" : {
            "import_only" : 0
         },
         "NT" : {
            "import_only" : 0
         },
         "NU" : {
            "import_only" : 0
         },
         "ON" : {
            "import_only" : 0
         },
         "PE" : {
            "import_only" : 0
         },
         "QC" : {
            "import_only" : 0
         },
         "SK" : {
            "import_only" : 0
         },
         "YT" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION100" : {
         "A" : {
            "import_only" : 0
         },
         "B" : {
            "import_only" : 0
         },
         "C" : {
            "import_only" : 0
         },
         "D" : {
            "import_only" : 0
         },
         "E" : {
            "import_only" : 0
         },
         "F" : {
            "import_only" : 0
         },
         "G" : {
            "import_only" : 0
         },
         "H" : {
            "import_only" : 0
         },
         "J" : {
            "import_only" : 0
         },
         "K" : {
            "import_only" : 0
         },
         "L" : {
            "import_only" : 0
         },
         "M" : {
            "import_only" : 0
         },
         "N" : {
            "import_only" : 0
         },
         "P" : {
            "import_only" : 0
         },
         "Q" : {
            "import_only" : 0
         },
         "R" : {
            "import_only" : 0
         },
         "S" : {
            "import_only" : 0
         },
         "T" : {
            "import_only" : 0
         },
         "U" : {
            "import_only" : 0
         },
         "V" : {
            "import_only" : 0
         },
         "W" : {
            "import_only" : 0
         },
         "X" : {
            "import_only" : 0
         },
         "Y" : {
            "import_only" : 0
         },
         "Z" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION108" : {
         "AC" : {
            "import_only" : 0
         },
         "AL" : {
            "import_only" : 0
         },
         "AM" : {
            "import_only" : 0
         },
         "AP" : {
            "import_only" : 0
         },
         "BA" : {
            "import_only" : 0
         },
         "CE" : {
            "import_only" : 0
         },
         "DF" : {
            "import_only" : 0
         },
         "ES" : {
            "import_only" : 0
         },
         "GO" : {
            "import_only" : 0
         },
         "MA" : {
            "import_only" : 0
         },
         "MG" : {
            "import_only" : 0
         },
         "MS" : {
            "import_only" : 0
         },
         "MT" : {
            "import_only" : 0
         },
         "PA" : {
            "import_only" : 0
         },
         "PB" : {
            "import_only" : 0
         },
         "PE" : {
            "import_only" : 0
         },
         "PI" : {
            "import_only" : 0
         },
         "PR" : {
            "import_only" : 0
         },
         "RJ" : {
            "import_only" : 0
         },
         "RN" : {
            "import_only" : 0
         },
         "RO" : {
            "import_only" : 0
         },
         "RR" : {
            "import_only" : 0
         },
         "RS" : {
            "import_only" : 0
         },
         "SC" : {
            "import_only" : 0
         },
         "SE" : {
            "import_only" : 0
         },
         "SP" : {
            "import_only" : 0
         },
         "TO" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION11" : {
         "AN" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION110" : {
         "HI" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION112" : {
         "AI" : {
            "import_only" : 0
         },
         "AN" : {
            "import_only" : 0
         },
         "AP" : {
            "import_only" : 0
         },
         "AR" : {
            "import_only" : 0
         },
         "AT" : {
            "import_only" : 0
         },
         "BI" : {
            "import_only" : 0
         },
         "CO" : {
            "import_only" : 0
         },
         "I" : {
            "import_only" : 1
         },
         "II" : {
            "import_only" : 1
         },
         "III" : {
            "import_only" : 1
         },
         "IV" : {
            "import_only" : 1
         },
         "IX" : {
            "import_only" : 1
         },
         "LI" : {
            "import_only" : 0
         },
         "LL" : {
            "import_only" : 0
         },
         "LR" : {
            "import_only" : 0
         },
         "MA" : {
            "import_only" : 0
         },
         "ML" : {
            "import_only" : 0
         },
         "NB" : {
            "import_only" : 0
         },
         "RM" : {
            "import_only" : 0
         },
         "TA" : {
            "import_only" : 0
         },
         "V" : {
            "import_only" : 1
         },
         "VI" : {
            "import_only" : 1
         },
         "VII" : {
            "import_only" : 1
         },
         "VIII" : {
            "import_only" : 1
         },
         "VS" : {
            "import_only" : 0
         },
         "X" : {
            "import_only" : 1
         },
         "XI" : {
            "import_only" : 1
         },
         "XII" : {
            "import_only" : 1
         },
         "XIV" : {
            "import_only" : 1
         },
         "XV" : {
            "import_only" : 1
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION118" : {
         "22" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION126" : {
         "KA" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION132" : {
         "01" : {
            "import_only" : 1
         },
         "02" : {
            "import_only" : 1
         },
         "03" : {
            "import_only" : 1
         },
         "04" : {
            "import_only" : 1
         },
         "05" : {
            "import_only" : 1
         },
         "06" : {
            "import_only" : 1
         },
         "07" : {
            "import_only" : 1
         },
         "08" : {
            "import_only" : 1
         },
         "09" : {
            "import_only" : 1
         },
         "1" : {
            "import_only" : 0
         },
         "10" : {
            "import_only" : 0
         },
         "11" : {
            "import_only" : 0
         },
         "12" : {
            "import_only" : 0
         },
         "13" : {
            "import_only" : 0
         },
         "14" : {
            "import_only" : 0
         },
         "15" : {
            "import_only" : 0
         },
         "16" : {
            "import_only" : 0
         },
         "19" : {
            "import_only" : 0
         },
         "2" : {
            "import_only" : 0
         },
         "3" : {
            "import_only" : 0
         },
         "4" : {
            "import_only" : 0
         },
         "5" : {
            "import_only" : 0
         },
         "6" : {
            "import_only" : 0
         },
         "7" : {
            "import_only" : 0
         },
         "8" : {
            "import_only" : 0
         },
         "9" : {
            "import_only" : 0
         },
         "ASU" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION137" : {
         "A" : {
            "import_only" : 0
         },
         "B" : {
            "import_only" : 0
         },
         "C" : {
            "import_only" : 0
         },
         "D" : {
            "import_only" : 0
         },
         "E" : {
            "import_only" : 0
         },
         "F" : {
            "import_only" : 0
         },
         "G" : {
            "import_only" : 0
         },
         "H" : {
            "import_only" : 0
         },
         "IS" : {
            "import_only" : 0
         },
         "K" : {
            "import_only" : 0
         },
         "L" : {
            "import_only" : 0
         },
         "M" : {
            "import_only" : 0
         },
         "N" : {
            "import_only" : 0
         },
         "P" : {
            "import_only" : 0
         },
         "Q" : {
            "import_only" : 0
         },
         "R" : {
            "import_only" : 0
         },
         "S" : {
            "import_only" : 0
         },
         "T" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION138" : {
         "KI" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION142" : {
         "LD" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION144" : {
         "AR" : {
            "import_only" : 0
         },
         "CA" : {
            "import_only" : 0
         },
         "CL" : {
            "import_only" : 0
         },
         "CO" : {
            "import_only" : 0
         },
         "DU" : {
            "import_only" : 0
         },
         "FD" : {
            "import_only" : 0
         },
         "FS" : {
            "import_only" : 0
         },
         "LA" : {
            "import_only" : 0
         },
         "MA" : {
            "import_only" : 0
         },
         "MO" : {
            "import_only" : 0
         },
         "PA" : {
            "import_only" : 0
         },
         "RN" : {
            "import_only" : 0
         },
         "RO" : {
            "import_only" : 0
         },
         "RV" : {
            "import_only" : 0
         },
         "SA" : {
            "import_only" : 0
         },
         "SJ" : {
            "import_only" : 0
         },
         "SO" : {
            "import_only" : 0
         },
         "TA" : {
            "import_only" : 0
         },
         "TT" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION147" : {
         "LH" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION148" : {
         "AM" : {
            "import_only" : 0
         },
         "AN" : {
            "import_only" : 0
         },
         "AP" : {
            "import_only" : 0
         },
         "AR" : {
            "import_only" : 0
         },
         "BA" : {
            "import_only" : 0
         },
         "BO" : {
            "import_only" : 0
         },
         "CA" : {
            "import_only" : 0
         },
         "CO" : {
            "import_only" : 0
         },
         "DA" : {
            "import_only" : 0
         },
         "DC" : {
            "import_only" : 0
         },
         "FA" : {
            "import_only" : 0
         },
         "GU" : {
            "import_only" : 0
         },
         "LA" : {
            "import_only" : 0
         },
         "ME" : {
            "import_only" : 0
         },
         "MI" : {
            "import_only" : 0
         },
         "MO" : {
            "import_only" : 0
         },
         "NE" : {
            "import_only" : 0
         },
         "PO" : {
            "import_only" : 0
         },
         "SU" : {
            "import_only" : 0
         },
         "TA" : {
            "import_only" : 0
         },
         "TR" : {
            "import_only" : 0
         },
         "VA" : {
            "import_only" : 0
         },
         "YA" : {
            "import_only" : 0
         },
         "ZU" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION149" : {
         "AC" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION15" : {
         "AB" : {
            "import_only" : 0
         },
         "AL" : {
            "import_only" : 0
         },
         "AM" : {
            "import_only" : 0
         },
         "BA" : {
            "import_only" : 0
         },
         "BU" : {
            "import_only" : 0
         },
         "CB" : {
            "import_only" : 0
         },
         "CK" : {
            "import_only" : 0
         },
         "CT" : {
            "import_only" : 0
         },
         "EA" : {
            "import_only" : 0
         },
         "EV" : {
            "import_only" : 0
         },
         "GA" : {
            "import_only" : 0
         },
         "HA" : {
            "import_only" : 0
         },
         "HK" : {
            "import_only" : 0
         },
         "HM" : {
            "import_only" : 0
         },
         "IR" : {
            "import_only" : 0
         },
         "KE" : {
            "import_only" : 0
         },
         "KK" : {
            "import_only" : 0
         },
         "KN" : {
            "import_only" : 0
         },
         "KO" : {
            "import_only" : 0
         },
         "KP" : {
            "import_only" : 0
         },
         "KT" : {
            "import_only" : 0
         },
         "KY" : {
            "import_only" : 0
         },
         "MG" : {
            "import_only" : 0
         },
         "NS" : {
            "import_only" : 0
         },
         "OB" : {
            "import_only" : 0
         },
         "OM" : {
            "import_only" : 0
         },
         "PK" : {
            "import_only" : 0
         },
         "PM" : {
            "import_only" : 0
         },
         "SL" : {
            "import_only" : 0
         },
         "SV" : {
            "import_only" : 0
         },
         "TM" : {
            "import_only" : 0
         },
         "TN" : {
            "import_only" : 0
         },
         "TO" : {
            "import_only" : 0
         },
         "TU" : {
            "import_only" : 0
         },
         "UO" : {
            "import_only" : 0
         },
         "YA" : {
            "import_only" : 0
         },
         "YN" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION150" : {
         "ACT" : {
            "import_only" : 0
         },
         "NSW" : {
            "import_only" : 0
         },
         "NT" : {
            "import_only" : 0
         },
         "QLD" : {
            "import_only" : 0
         },
         "SA" : {
            "import_only" : 0
         },
         "TAS" : {
            "import_only" : 0
         },
         "VIC" : {
            "import_only" : 0
         },
         "WA" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION151" : {
         "LO" : {
            "import_only" : 0
         },
         "MV" : {
            "import_only" : 1
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION153" : {
         "MA" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION163" : {
         "CPK" : {
            "import_only" : 0
         },
         "CPM" : {
            "import_only" : 0
         },
         "EBR" : {
            "import_only" : 0
         },
         "EHG" : {
            "import_only" : 0
         },
         "EPW" : {
            "import_only" : 0
         },
         "ESW" : {
            "import_only" : 0
         },
         "GPK" : {
            "import_only" : 0
         },
         "HLA" : {
            "import_only" : 0
         },
         "JWK" : {
            "import_only" : 0
         },
         "MBA" : {
            "import_only" : 0
         },
         "MPL" : {
            "import_only" : 0
         },
         "MPM" : {
            "import_only" : 0
         },
         "MRL" : {
            "import_only" : 0
         },
         "NCD" : {
            "import_only" : 0
         },
         "NIK" : {
            "import_only" : 0
         },
         "NPP" : {
            "import_only" : 0
         },
         "NSA" : {
            "import_only" : 1
         },
         "NSB" : {
            "import_only" : 0
         },
         "SAN" : {
            "import_only" : 0
         },
         "SHM" : {
            "import_only" : 0
         },
         "WBK" : {
            "import_only" : 0
         },
         "WBR" : {
            "import_only" : 1
         },
         "WHM" : {
            "import_only" : 0
         },
         "WPD" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION170" : {
         "AUK" : {
            "import_only" : 0
         },
         "BOP" : {
            "import_only" : 0
         },
         "CAN" : {
            "import_only" : 0
         },
         "GIS" : {
            "import_only" : 0
         },
         "HKB" : {
            "import_only" : 0
         },
         "MBH" : {
            "import_only" : 0
         },
         "MWT" : {
            "import_only" : 0
         },
         "NSN" : {
            "import_only" : 0
         },
         "NTL" : {
            "import_only" : 0
         },
         "OTA" : {
            "import_only" : 0
         },
         "STL" : {
            "import_only" : 0
         },
         "TAS" : {
            "import_only" : 0
         },
         "TKI" : {
            "import_only" : 0
         },
         "WGN" : {
            "import_only" : 0
         },
         "WKO" : {
            "import_only" : 0
         },
         "WTC" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION177" : {
         "MT" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION192" : {
         "O" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION206" : {
         "AM" : {
            "import_only" : 0
         },
         "BA" : {
            "import_only" : 0
         },
         "BC" : {
            "import_only" : 0
         },
         "BL" : {
            "import_only" : 0
         },
         "BM" : {
            "import_only" : 0
         },
         "BN" : {
            "import_only" : 0
         },
         "BR" : {
            "import_only" : 0
         },
         "BZ" : {
            "import_only" : 0
         },
         "DL" : {
            "import_only" : 0
         },
         "DO" : {
            "import_only" : 0
         },
         "EC" : {
            "import_only" : 0
         },
         "EF" : {
            "import_only" : 0
         },
         "EU" : {
            "import_only" : 0
         },
         "FB" : {
            "import_only" : 0
         },
         "FE" : {
            "import_only" : 0
         },
         "FF" : {
            "import_only" : 0
         },
         "FK" : {
            "import_only" : 0
         },
         "FR" : {
            "import_only" : 0
         },
         "GB" : {
            "import_only" : 0
         },
         "GC" : {
            "import_only" : 0
         },
         "GD" : {
            "import_only" : 0
         },
         "GF" : {
            "import_only" : 0
         },
         "GM" : {
            "import_only" : 0
         },
         "GR" : {
            "import_only" : 0
         },
         "GS" : {
            "import_only" : 0
         },
         "GU" : {
            "import_only" : 0
         },
         "HA" : {
            "import_only" : 0
         },
         "HB" : {
            "import_only" : 0
         },
         "HE" : {
            "import_only" : 0
         },
         "HF" : {
            "import_only" : 0
         },
         "HL" : {
            "import_only" : 0
         },
         "HO" : {
            "import_only" : 0
         },
         "IC" : {
            "import_only" : 0
         },
         "IL" : {
            "import_only" : 0
         },
         "IM" : {
            "import_only" : 0
         },
         "JE" : {
            "import_only" : 0
         },
         "JO" : {
            "import_only" : 0
         },
         "JU" : {
            "import_only" : 0
         },
         "KB" : {
            "import_only" : 0
         },
         "KC" : {
            "import_only" : 0
         },
         "KF" : {
            "import_only" : 0
         },
         "KI" : {
            "import_only" : 0
         },
         "KL" : {
            "import_only" : 0
         },
         "KO" : {
            "import_only" : 0
         },
         "KR" : {
            "import_only" : 0
         },
         "KS" : {
            "import_only" : 0
         },
         "KU" : {
            "import_only" : 0
         },
         "LA" : {
            "import_only" : 0
         },
         "LB" : {
            "import_only" : 0
         },
         "LC" : {
            "import_only" : 0
         },
         "LE" : {
            "import_only" : 0
         },
         "LF" : {
            "import_only" : 0
         },
         "LI" : {
            "import_only" : 0
         },
         "LL" : {
            "import_only" : 0
         },
         "LN" : {
            "import_only" : 0
         },
         "LZ" : {
            "import_only" : 0
         },
         "MA" : {
            "import_only" : 0
         },
         "MD" : {
            "import_only" : 0
         },
         "ME" : {
            "import_only" : 0
         },
         "MI" : {
            "import_only" : 0
         },
         "MT" : {
            "import_only" : 0
         },
         "MU" : {
            "import_only" : 0
         },
         "MZ" : {
            "import_only" : 0
         },
         "ND" : {
            "import_only" : 0
         },
         "NK" : {
            "import_only" : 0
         },
         "OP" : {
            "import_only" : 0
         },
         "OW" : {
            "import_only" : 0
         },
         "PC" : {
            "import_only" : 0
         },
         "PE" : {
            "import_only" : 0
         },
         "PL" : {
            "import_only" : 0
         },
         "RA" : {
            "import_only" : 0
         },
         "RE" : {
            "import_only" : 0
         },
         "RI" : {
            "import_only" : 0
         },
         "RO" : {
            "import_only" : 0
         },
         "SB" : {
            "import_only" : 0
         },
         "SC" : {
            "import_only" : 0
         },
         "SD" : {
            "import_only" : 0
         },
         "SE" : {
            "import_only" : 0
         },
         "SL" : {
            "import_only" : 0
         },
         "SO" : {
            "import_only" : 0
         },
         "SP" : {
            "import_only" : 0
         },
         "SR" : {
            "import_only" : 0
         },
         "SV" : {
            "import_only" : 0
         },
         "SW" : {
            "import_only" : 0
         },
         "SZ" : {
            "import_only" : 0
         },
         "TA" : {
            "import_only" : 0
         },
         "TU" : {
            "import_only" : 0
         },
         "UU" : {
            "import_only" : 0
         },
         "VB" : {
            "import_only" : 0
         },
         "VI" : {
            "import_only" : 0
         },
         "VK" : {
            "import_only" : 0
         },
         "VL" : {
            "import_only" : 0
         },
         "VO" : {
            "import_only" : 0
         },
         "WB" : {
            "import_only" : 0
         },
         "WC" : {
            "import_only" : 0
         },
         "WE" : {
            "import_only" : 0
         },
         "WL" : {
            "import_only" : 0
         },
         "WN" : {
            "import_only" : 0
         },
         "WO" : {
            "import_only" : 0
         },
         "WT" : {
            "import_only" : 0
         },
         "WU" : {
            "import_only" : 0
         },
         "WY" : {
            "import_only" : 0
         },
         "WZ" : {
            "import_only" : 0
         },
         "ZE" : {
            "import_only" : 0
         },
         "ZT" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION209" : {
         "AN" : {
            "import_only" : 0
         },
         "BR" : {
            "import_only" : 0
         },
         "BW" : {
            "import_only" : 0
         },
         "HT" : {
            "import_only" : 0
         },
         "LB" : {
            "import_only" : 0
         },
         "LG" : {
            "import_only" : 0
         },
         "LU" : {
            "import_only" : 0
         },
         "NM" : {
            "import_only" : 0
         },
         "OV" : {
            "import_only" : 0
         },
         "VB" : {
            "import_only" : 0
         },
         "WV" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION21" : {
         "IB" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION212" : {
         "BL" : {
            "import_only" : 0
         },
         "BU" : {
            "import_only" : 0
         },
         "DO" : {
            "import_only" : 0
         },
         "GA" : {
            "import_only" : 0
         },
         "HA" : {
            "import_only" : 0
         },
         "KA" : {
            "import_only" : 0
         },
         "KD" : {
            "import_only" : 0
         },
         "LV" : {
            "import_only" : 0
         },
         "MN" : {
            "import_only" : 0
         },
         "PA" : {
            "import_only" : 0
         },
         "PD" : {
            "import_only" : 0
         },
         "PK" : {
            "import_only" : 0
         },
         "PL" : {
            "import_only" : 0
         },
         "RS" : {
            "import_only" : 0
         },
         "RZ" : {
            "import_only" : 0
         },
         "SF" : {
            "import_only" : 0
         },
         "SL" : {
            "import_only" : 0
         },
         "SM" : {
            "import_only" : 0
         },
         "SN" : {
            "import_only" : 0
         },
         "SO" : {
            "import_only" : 0
         },
         "SS" : {
            "import_only" : 0
         },
         "SZ" : {
            "import_only" : 0
         },
         "TA" : {
            "import_only" : 0
         },
         "VD" : {
            "import_only" : 0
         },
         "VN" : {
            "import_only" : 0
         },
         "VR" : {
            "import_only" : 0
         },
         "VT" : {
            "import_only" : 0
         },
         "YA" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION214" : {
         "2A" : {
            "import_only" : 0
         },
         "2B" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION221" : {
         "015" : {
            "import_only" : 0
         },
         "020" : {
            "import_only" : 0
         },
         "025" : {
            "import_only" : 0
         },
         "030" : {
            "import_only" : 0
         },
         "035" : {
            "import_only" : 0
         },
         "040" : {
            "import_only" : 0
         },
         "042" : {
            "import_only" : 0
         },
         "050" : {
            "import_only" : 0
         },
         "055" : {
            "import_only" : 0
         },
         "060" : {
            "import_only" : 0
         },
         "065" : {
            "import_only" : 0
         },
         "070" : {
            "import_only" : 0
         },
         "076" : {
            "import_only" : 0
         },
         "080" : {
            "import_only" : 0
         },
         "101" : {
            "import_only" : 0
         },
         "147" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION224" : {
         "100" : {
            "import_only" : 0
         },
         "102" : {
            "import_only" : 0
         },
         "103" : {
            "import_only" : 0
         },
         "104" : {
            "import_only" : 0
         },
         "105" : {
            "import_only" : 0
         },
         "106" : {
            "import_only" : 0
         },
         "107" : {
            "import_only" : 0
         },
         "108" : {
            "import_only" : 0
         },
         "109" : {
            "import_only" : 0
         },
         "110" : {
            "import_only" : 0
         },
         "111" : {
            "import_only" : 0
         },
         "112" : {
            "import_only" : 0
         },
         "115" : {
            "import_only" : 0
         },
         "116" : {
            "import_only" : 0
         },
         "117" : {
            "import_only" : 0
         },
         "119" : {
            "import_only" : 0
         },
         "120" : {
            "import_only" : 0
         },
         "122" : {
            "import_only" : 0
         },
         "123" : {
            "import_only" : 0
         },
         "124" : {
            "import_only" : 0
         },
         "126" : {
            "import_only" : 0
         },
         "128" : {
            "import_only" : 0
         },
         "129" : {
            "import_only" : 0
         },
         "130" : {
            "import_only" : 0
         },
         "131" : {
            "import_only" : 0
         },
         "132" : {
            "import_only" : 0
         },
         "133" : {
            "import_only" : 0
         },
         "134" : {
            "import_only" : 0
         },
         "135" : {
            "import_only" : 0
         },
         "136" : {
            "import_only" : 0
         },
         "137" : {
            "import_only" : 0
         },
         "138" : {
            "import_only" : 0
         },
         "139" : {
            "import_only" : 0
         },
         "140" : {
            "import_only" : 0
         },
         "141" : {
            "import_only" : 0
         },
         "142" : {
            "import_only" : 0
         },
         "143" : {
            "import_only" : 0
         },
         "144" : {
            "import_only" : 0
         },
         "145" : {
            "import_only" : 0
         },
         "147" : {
            "import_only" : 0
         },
         "148" : {
            "import_only" : 0
         },
         "149" : {
            "import_only" : 0
         },
         "150" : {
            "import_only" : 0
         },
         "151" : {
            "import_only" : 0
         },
         "152" : {
            "import_only" : 0
         },
         "154" : {
            "import_only" : 0
         },
         "156" : {
            "import_only" : 0
         },
         "157" : {
            "import_only" : 0
         },
         "158" : {
            "import_only" : 0
         },
         "159" : {
            "import_only" : 0
         },
         "160" : {
            "import_only" : 0
         },
         "161" : {
            "import_only" : 0
         },
         "162" : {
            "import_only" : 0
         },
         "163" : {
            "import_only" : 0
         },
         "164" : {
            "import_only" : 0
         },
         "165" : {
            "import_only" : 0
         },
         "167" : {
            "import_only" : 0
         },
         "168" : {
            "import_only" : 0
         },
         "169" : {
            "import_only" : 0
         },
         "170" : {
            "import_only" : 0
         },
         "171" : {
            "import_only" : 0
         },
         "172" : {
            "import_only" : 0
         },
         "173" : {
            "import_only" : 0
         },
         "174" : {
            "import_only" : 0
         },
         "175" : {
            "import_only" : 0
         },
         "176" : {
            "import_only" : 0
         },
         "178" : {
            "import_only" : 0
         },
         "179" : {
            "import_only" : 0
         },
         "180" : {
            "import_only" : 0
         },
         "181" : {
            "import_only" : 0
         },
         "182" : {
            "import_only" : 0
         },
         "183" : {
            "import_only" : 0
         },
         "184" : {
            "import_only" : 0
         },
         "185" : {
            "import_only" : 0
         },
         "186" : {
            "import_only" : 0
         },
         "187" : {
            "import_only" : 0
         },
         "188" : {
            "import_only" : 0
         },
         "189" : {
            "import_only" : 0
         },
         "190" : {
            "import_only" : 0
         },
         "191" : {
            "import_only" : 0
         },
         "192" : {
            "import_only" : 0
         },
         "193" : {
            "import_only" : 0
         },
         "194" : {
            "import_only" : 0
         },
         "195" : {
            "import_only" : 0
         },
         "196" : {
            "import_only" : 0
         },
         "198" : {
            "import_only" : 0
         },
         "199" : {
            "import_only" : 0
         },
         "201" : {
            "import_only" : 0
         },
         "202" : {
            "import_only" : 0
         },
         "204" : {
            "import_only" : 0
         },
         "205" : {
            "import_only" : 0
         },
         "206" : {
            "import_only" : 0
         },
         "207" : {
            "import_only" : 0
         },
         "208" : {
            "import_only" : 0
         },
         "209" : {
            "import_only" : 0
         },
         "210" : {
            "import_only" : 0
         },
         "211" : {
            "import_only" : 0
         },
         "212" : {
            "import_only" : 0
         },
         "213" : {
            "import_only" : 0
         },
         "214" : {
            "import_only" : 0
         },
         "215" : {
            "import_only" : 0
         },
         "216" : {
            "import_only" : 0
         },
         "217" : {
            "import_only" : 0
         },
         "218" : {
            "import_only" : 0
         },
         "220" : {
            "import_only" : 0
         },
         "221" : {
            "import_only" : 0
         },
         "222" : {
            "import_only" : 0
         },
         "223" : {
            "import_only" : 0
         },
         "224" : {
            "import_only" : 0
         },
         "225" : {
            "import_only" : 0
         },
         "226" : {
            "import_only" : 0
         },
         "227" : {
            "import_only" : 0
         },
         "228" : {
            "import_only" : 0
         },
         "229" : {
            "import_only" : 0
         },
         "231" : {
            "import_only" : 0
         },
         "233" : {
            "import_only" : 0
         },
         "234" : {
            "import_only" : 0
         },
         "235" : {
            "import_only" : 0
         },
         "236" : {
            "import_only" : 0
         },
         "238" : {
            "import_only" : 0
         },
         "241" : {
            "import_only" : 0
         },
         "242" : {
            "import_only" : 0
         },
         "243" : {
            "import_only" : 0
         },
         "301" : {
            "import_only" : 0
         },
         "303" : {
            "import_only" : 0
         },
         "304" : {
            "import_only" : 0
         },
         "305" : {
            "import_only" : 0
         },
         "306" : {
            "import_only" : 0
         },
         "307" : {
            "import_only" : 0
         },
         "308" : {
            "import_only" : 0
         },
         "309" : {
            "import_only" : 0
         },
         "310" : {
            "import_only" : 0
         },
         "311" : {
            "import_only" : 0
         },
         "312" : {
            "import_only" : 0
         },
         "313" : {
            "import_only" : 0
         },
         "314" : {
            "import_only" : 0
         },
         "315" : {
            "import_only" : 0
         },
         "316" : {
            "import_only" : 0
         },
         "318" : {
            "import_only" : 0
         },
         "319" : {
            "import_only" : 0
         },
         "320" : {
            "import_only" : 0
         },
         "321" : {
            "import_only" : 0
         },
         "322" : {
            "import_only" : 0
         },
         "323" : {
            "import_only" : 0
         },
         "324" : {
            "import_only" : 0
         },
         "325" : {
            "import_only" : 0
         },
         "326" : {
            "import_only" : 0
         },
         "327" : {
            "import_only" : 0
         },
         "328" : {
            "import_only" : 0
         },
         "329" : {
            "import_only" : 0
         },
         "330" : {
            "import_only" : 0
         },
         "331" : {
            "import_only" : 0
         },
         "332" : {
            "import_only" : 0
         },
         "333" : {
            "import_only" : 0
         },
         "334" : {
            "import_only" : 0
         },
         "335" : {
            "import_only" : 0
         },
         "336" : {
            "import_only" : 0
         },
         "337" : {
            "import_only" : 0
         },
         "340" : {
            "import_only" : 0
         },
         "341" : {
            "import_only" : 0
         },
         "342" : {
            "import_only" : 0
         },
         "344" : {
            "import_only" : 0
         },
         "345" : {
            "import_only" : 0
         },
         "346" : {
            "import_only" : 0
         },
         "347" : {
            "import_only" : 0
         },
         "348" : {
            "import_only" : 0
         },
         "349" : {
            "import_only" : 0
         },
         "350" : {
            "import_only" : 0
         },
         "351" : {
            "import_only" : 0
         },
         "352" : {
            "import_only" : 0
         },
         "353" : {
            "import_only" : 0
         },
         "354" : {
            "import_only" : 0
         },
         "355" : {
            "import_only" : 0
         },
         "356" : {
            "import_only" : 0
         },
         "357" : {
            "import_only" : 0
         },
         "358" : {
            "import_only" : 0
         },
         "402" : {
            "import_only" : 0
         },
         "403" : {
            "import_only" : 0
         },
         "404" : {
            "import_only" : 0
         },
         "405" : {
            "import_only" : 0
         },
         "407" : {
            "import_only" : 0
         },
         "408" : {
            "import_only" : 0
         },
         "409" : {
            "import_only" : 0
         },
         "410" : {
            "import_only" : 0
         },
         "411" : {
            "import_only" : 0
         },
         "412" : {
            "import_only" : 0
         },
         "413" : {
            "import_only" : 0
         },
         "414" : {
            "import_only" : 0
         },
         "415" : {
            "import_only" : 0
         },
         "417" : {
            "import_only" : 0
         },
         "418" : {
            "import_only" : 0
         },
         "419" : {
            "import_only" : 0
         },
         "420" : {
            "import_only" : 0
         },
         "421" : {
            "import_only" : 0
         },
         "422" : {
            "import_only" : 0
         },
         "423" : {
            "import_only" : 0
         },
         "424" : {
            "import_only" : 0
         },
         "425" : {
            "import_only" : 0
         },
         "426" : {
            "import_only" : 0
         },
         "427" : {
            "import_only" : 0
         },
         "428" : {
            "import_only" : 0
         },
         "502" : {
            "import_only" : 0
         },
         "503" : {
            "import_only" : 0
         },
         "504" : {
            "import_only" : 0
         },
         "505" : {
            "import_only" : 0
         },
         "506" : {
            "import_only" : 0
         },
         "507" : {
            "import_only" : 0
         },
         "509" : {
            "import_only" : 0
         },
         "510" : {
            "import_only" : 0
         },
         "511" : {
            "import_only" : 0
         },
         "513" : {
            "import_only" : 0
         },
         "514" : {
            "import_only" : 0
         },
         "515" : {
            "import_only" : 0
         },
         "516" : {
            "import_only" : 0
         },
         "518" : {
            "import_only" : 0
         },
         "519" : {
            "import_only" : 0
         },
         "520" : {
            "import_only" : 0
         },
         "521" : {
            "import_only" : 0
         },
         "522" : {
            "import_only" : 0
         },
         "523" : {
            "import_only" : 0
         },
         "525" : {
            "import_only" : 0
         },
         "526" : {
            "import_only" : 0
         },
         "527" : {
            "import_only" : 0
         },
         "528" : {
            "import_only" : 0
         },
         "530" : {
            "import_only" : 0
         },
         "531" : {
            "import_only" : 0
         },
         "532" : {
            "import_only" : 0
         },
         "601" : {
            "import_only" : 0
         },
         "602" : {
            "import_only" : 0
         },
         "603" : {
            "import_only" : 0
         },
         "604" : {
            "import_only" : 0
         },
         "605" : {
            "import_only" : 0
         },
         "606" : {
            "import_only" : 0
         },
         "607" : {
            "import_only" : 0
         },
         "608" : {
            "import_only" : 0
         },
         "609" : {
            "import_only" : 0
         },
         "610" : {
            "import_only" : 0
         },
         "611" : {
            "import_only" : 0
         },
         "612" : {
            "import_only" : 0
         },
         "613" : {
            "import_only" : 0
         },
         "614" : {
            "import_only" : 0
         },
         "615" : {
            "import_only" : 0
         },
         "616" : {
            "import_only" : 0
         },
         "617" : {
            "import_only" : 0
         },
         "619" : {
            "import_only" : 0
         },
         "620" : {
            "import_only" : 0
         },
         "621" : {
            "import_only" : 0
         },
         "622" : {
            "import_only" : 0
         },
         "623" : {
            "import_only" : 0
         },
         "624" : {
            "import_only" : 0
         },
         "625" : {
            "import_only" : 0
         },
         "626" : {
            "import_only" : 0
         },
         "627" : {
            "import_only" : 0
         },
         "628" : {
            "import_only" : 0
         },
         "629" : {
            "import_only" : 0
         },
         "630" : {
            "import_only" : 0
         },
         "632" : {
            "import_only" : 0
         },
         "633" : {
            "import_only" : 0
         },
         "634" : {
            "import_only" : 0
         },
         "635" : {
            "import_only" : 0
         },
         "636" : {
            "import_only" : 0
         },
         "637" : {
            "import_only" : 0
         },
         "638" : {
            "import_only" : 0
         },
         "639" : {
            "import_only" : 0
         },
         "640" : {
            "import_only" : 0
         },
         "641" : {
            "import_only" : 0
         },
         "642" : {
            "import_only" : 0
         },
         "643" : {
            "import_only" : 0
         },
         "644" : {
            "import_only" : 0
         },
         "645" : {
            "import_only" : 0
         },
         "646" : {
            "import_only" : 0
         },
         "647" : {
            "import_only" : 0
         },
         "648" : {
            "import_only" : 0
         },
         "649" : {
            "import_only" : 0
         },
         "650" : {
            "import_only" : 0
         },
         "651" : {
            "import_only" : 0
         },
         "652" : {
            "import_only" : 0
         },
         "653" : {
            "import_only" : 0
         },
         "654" : {
            "import_only" : 0
         },
         "655" : {
            "import_only" : 0
         },
         "656" : {
            "import_only" : 0
         },
         "657" : {
            "import_only" : 0
         },
         "658" : {
            "import_only" : 0
         },
         "659" : {
            "import_only" : 0
         },
         "660" : {
            "import_only" : 0
         },
         "661" : {
            "import_only" : 0
         },
         "662" : {
            "import_only" : 0
         },
         "663" : {
            "import_only" : 0
         },
         "664" : {
            "import_only" : 0
         },
         "665" : {
            "import_only" : 0
         },
         "666" : {
            "import_only" : 0
         },
         "668" : {
            "import_only" : 0
         },
         "669" : {
            "import_only" : 0
         },
         "670" : {
            "import_only" : 0
         },
         "671" : {
            "import_only" : 0
         },
         "672" : {
            "import_only" : 0
         },
         "673" : {
            "import_only" : 0
         },
         "675" : {
            "import_only" : 0
         },
         "676" : {
            "import_only" : 0
         },
         "677" : {
            "import_only" : 0
         },
         "678" : {
            "import_only" : 0
         },
         "679" : {
            "import_only" : 0
         },
         "680" : {
            "import_only" : 0
         },
         "681" : {
            "import_only" : 0
         },
         "682" : {
            "import_only" : 0
         },
         "683" : {
            "import_only" : 0
         },
         "684" : {
            "import_only" : 0
         },
         "685" : {
            "import_only" : 0
         },
         "686" : {
            "import_only" : 0
         },
         "687" : {
            "import_only" : 0
         },
         "688" : {
            "import_only" : 0
         },
         "689" : {
            "import_only" : 0
         },
         "690" : {
            "import_only" : 0
         },
         "692" : {
            "import_only" : 0
         },
         "701" : {
            "import_only" : 0
         },
         "702" : {
            "import_only" : 0
         },
         "703" : {
            "import_only" : 0
         },
         "704" : {
            "import_only" : 0
         },
         "705" : {
            "import_only" : 0
         },
         "706" : {
            "import_only" : 0
         },
         "707" : {
            "import_only" : 0
         },
         "708" : {
            "import_only" : 0
         },
         "709" : {
            "import_only" : 0
         },
         "710" : {
            "import_only" : 0
         },
         "711" : {
            "import_only" : 0
         },
         "712" : {
            "import_only" : 0
         },
         "713" : {
            "import_only" : 0
         },
         "714" : {
            "import_only" : 0
         },
         "715" : {
            "import_only" : 0
         },
         "716" : {
            "import_only" : 0
         },
         "717" : {
            "import_only" : 0
         },
         "718" : {
            "import_only" : 0
         },
         "719" : {
            "import_only" : 0
         },
         "720" : {
            "import_only" : 0
         },
         "721" : {
            "import_only" : 0
         },
         "722" : {
            "import_only" : 0
         },
         "723" : {
            "import_only" : 0
         },
         "724" : {
            "import_only" : 0
         },
         "725" : {
            "import_only" : 0
         },
         "726" : {
            "import_only" : 0
         },
         "727" : {
            "import_only" : 0
         },
         "728" : {
            "import_only" : 0
         },
         "729" : {
            "import_only" : 0
         },
         "730" : {
            "import_only" : 0
         },
         "731" : {
            "import_only" : 0
         },
         "732" : {
            "import_only" : 0
         },
         "733" : {
            "import_only" : 0
         },
         "734" : {
            "import_only" : 0
         },
         "735" : {
            "import_only" : 0
         },
         "736" : {
            "import_only" : 0
         },
         "737" : {
            "import_only" : 0
         },
         "738" : {
            "import_only" : 0
         },
         "739" : {
            "import_only" : 0
         },
         "740" : {
            "import_only" : 0
         },
         "741" : {
            "import_only" : 0
         },
         "742" : {
            "import_only" : 0
         },
         "743" : {
            "import_only" : 0
         },
         "801" : {
            "import_only" : 0
         },
         "802" : {
            "import_only" : 0
         },
         "803" : {
            "import_only" : 0
         },
         "804" : {
            "import_only" : 0
         },
         "805" : {
            "import_only" : 0
         },
         "806" : {
            "import_only" : 0
         },
         "807" : {
            "import_only" : 0
         },
         "808" : {
            "import_only" : 0
         },
         "810" : {
            "import_only" : 0
         },
         "811" : {
            "import_only" : 0
         },
         "812" : {
            "import_only" : 0
         },
         "813" : {
            "import_only" : 0
         },
         "814" : {
            "import_only" : 0
         },
         "815" : {
            "import_only" : 0
         },
         "816" : {
            "import_only" : 0
         },
         "817" : {
            "import_only" : 0
         },
         "818" : {
            "import_only" : 0
         },
         "819" : {
            "import_only" : 0
         },
         "820" : {
            "import_only" : 0
         },
         "821" : {
            "import_only" : 0
         },
         "822" : {
            "import_only" : 0
         },
         "823" : {
            "import_only" : 0
         },
         "824" : {
            "import_only" : 0
         },
         "825" : {
            "import_only" : 0
         },
         "826" : {
            "import_only" : 0
         },
         "827" : {
            "import_only" : 0
         },
         "828" : {
            "import_only" : 0
         },
         "829" : {
            "import_only" : 0
         },
         "830" : {
            "import_only" : 0
         },
         "831" : {
            "import_only" : 0
         },
         "832" : {
            "import_only" : 0
         },
         "833" : {
            "import_only" : 0
         },
         "834" : {
            "import_only" : 0
         },
         "835" : {
            "import_only" : 0
         },
         "836" : {
            "import_only" : 0
         },
         "837" : {
            "import_only" : 0
         },
         "838" : {
            "import_only" : 0
         },
         "839" : {
            "import_only" : 0
         },
         "840" : {
            "import_only" : 0
         },
         "841" : {
            "import_only" : 0
         },
         "842" : {
            "import_only" : 0
         },
         "843" : {
            "import_only" : 0
         },
         "844" : {
            "import_only" : 0
         },
         "846" : {
            "import_only" : 0
         },
         "847" : {
            "import_only" : 0
         },
         "848" : {
            "import_only" : 0
         },
         "849" : {
            "import_only" : 0
         },
         "850" : {
            "import_only" : 0
         },
         "851" : {
            "import_only" : 0
         },
         "852" : {
            "import_only" : 0
         },
         "853" : {
            "import_only" : 0
         },
         "901" : {
            "import_only" : 0
         },
         "902" : {
            "import_only" : 0
         },
         "903" : {
            "import_only" : 0
         },
         "904" : {
            "import_only" : 0
         },
         "905" : {
            "import_only" : 0
         },
         "907" : {
            "import_only" : 0
         },
         "908" : {
            "import_only" : 0
         },
         "909" : {
            "import_only" : 0
         },
         "910" : {
            "import_only" : 0
         },
         "911" : {
            "import_only" : 0
         },
         "912" : {
            "import_only" : 0
         },
         "913" : {
            "import_only" : 0
         },
         "914" : {
            "import_only" : 0
         },
         "915" : {
            "import_only" : 0
         },
         "916" : {
            "import_only" : 0
         },
         "917" : {
            "import_only" : 0
         },
         "918" : {
            "import_only" : 0
         },
         "919" : {
            "import_only" : 0
         },
         "920" : {
            "import_only" : 0
         },
         "921" : {
            "import_only" : 0
         },
         "922" : {
            "import_only" : 0
         },
         "923" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION225" : {
         "CA" : {
            "import_only" : 0
         },
         "CI" : {
            "import_only" : 1
         },
         "MD" : {
            "import_only" : 1
         },
         "NU" : {
            "import_only" : 0
         },
         "OG" : {
            "import_only" : 0
         },
         "OR" : {
            "import_only" : 0
         },
         "OT" : {
            "import_only" : 0
         },
         "SS" : {
            "import_only" : 0
         },
         "SU" : {
            "import_only" : 0
         },
         "VS" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION227" : {
         "01" : {
            "import_only" : 0
         },
         "02" : {
            "import_only" : 0
         },
         "03" : {
            "import_only" : 0
         },
         "04" : {
            "import_only" : 0
         },
         "05" : {
            "import_only" : 0
         },
         "06" : {
            "import_only" : 0
         },
         "07" : {
            "import_only" : 0
         },
         "08" : {
            "import_only" : 0
         },
         "09" : {
            "import_only" : 0
         },
         "10" : {
            "import_only" : 0
         },
         "11" : {
            "import_only" : 0
         },
         "12" : {
            "import_only" : 0
         },
         "13" : {
            "import_only" : 0
         },
         "14" : {
            "import_only" : 0
         },
         "15" : {
            "import_only" : 0
         },
         "16" : {
            "import_only" : 0
         },
         "17" : {
            "import_only" : 0
         },
         "18" : {
            "import_only" : 0
         },
         "19" : {
            "import_only" : 0
         },
         "21" : {
            "import_only" : 0
         },
         "22" : {
            "import_only" : 0
         },
         "23" : {
            "import_only" : 0
         },
         "24" : {
            "import_only" : 0
         },
         "25" : {
            "import_only" : 0
         },
         "26" : {
            "import_only" : 0
         },
         "27" : {
            "import_only" : 0
         },
         "28" : {
            "import_only" : 0
         },
         "29" : {
            "import_only" : 0
         },
         "30" : {
            "import_only" : 0
         },
         "31" : {
            "import_only" : 0
         },
         "32" : {
            "import_only" : 0
         },
         "33" : {
            "import_only" : 0
         },
         "34" : {
            "import_only" : 0
         },
         "35" : {
            "import_only" : 0
         },
         "36" : {
            "import_only" : 0
         },
         "37" : {
            "import_only" : 0
         },
         "38" : {
            "import_only" : 0
         },
         "39" : {
            "import_only" : 0
         },
         "40" : {
            "import_only" : 0
         },
         "41" : {
            "import_only" : 0
         },
         "42" : {
            "import_only" : 0
         },
         "43" : {
            "import_only" : 0
         },
         "44" : {
            "import_only" : 0
         },
         "45" : {
            "import_only" : 0
         },
         "46" : {
            "import_only" : 0
         },
         "47" : {
            "import_only" : 0
         },
         "48" : {
            "import_only" : 0
         },
         "49" : {
            "import_only" : 0
         },
         "50" : {
            "import_only" : 0
         },
         "51" : {
            "import_only" : 0
         },
         "52" : {
            "import_only" : 0
         },
         "53" : {
            "import_only" : 0
         },
         "54" : {
            "import_only" : 0
         },
         "55" : {
            "import_only" : 0
         },
         "56" : {
            "import_only" : 0
         },
         "57" : {
            "import_only" : 0
         },
         "58" : {
            "import_only" : 0
         },
         "59" : {
            "import_only" : 0
         },
         "60" : {
            "import_only" : 0
         },
         "61" : {
            "import_only" : 0
         },
         "62" : {
            "import_only" : 0
         },
         "63" : {
            "import_only" : 0
         },
         "64" : {
            "import_only" : 0
         },
         "65" : {
            "import_only" : 0
         },
         "66" : {
            "import_only" : 0
         },
         "67" : {
            "import_only" : 0
         },
         "68" : {
            "import_only" : 0
         },
         "69" : {
            "import_only" : 0
         },
         "70" : {
            "import_only" : 0
         },
         "71" : {
            "import_only" : 0
         },
         "72" : {
            "import_only" : 0
         },
         "73" : {
            "import_only" : 0
         },
         "74" : {
            "import_only" : 0
         },
         "75" : {
            "import_only" : 0
         },
         "76" : {
            "import_only" : 0
         },
         "77" : {
            "import_only" : 0
         },
         "78" : {
            "import_only" : 0
         },
         "79" : {
            "import_only" : 0
         },
         "80" : {
            "import_only" : 0
         },
         "81" : {
            "import_only" : 0
         },
         "82" : {
            "import_only" : 0
         },
         "83" : {
            "import_only" : 0
         },
         "84" : {
            "import_only" : 0
         },
         "85" : {
            "import_only" : 0
         },
         "86" : {
            "import_only" : 0
         },
         "87" : {
            "import_only" : 0
         },
         "88" : {
            "import_only" : 0
         },
         "89" : {
            "import_only" : 0
         },
         "90" : {
            "import_only" : 0
         },
         "91" : {
            "import_only" : 0
         },
         "92" : {
            "import_only" : 0
         },
         "93" : {
            "import_only" : 0
         },
         "94" : {
            "import_only" : 0
         },
         "95" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION230" : {
         "BB" : {
            "import_only" : 0
         },
         "BE" : {
            "import_only" : 0
         },
         "BW" : {
            "import_only" : 0
         },
         "BY" : {
            "import_only" : 0
         },
         "HB" : {
            "import_only" : 0
         },
         "HE" : {
            "import_only" : 0
         },
         "HH" : {
            "import_only" : 0
         },
         "MV" : {
            "import_only" : 0
         },
         "NI" : {
            "import_only" : 0
         },
         "NW" : {
            "import_only" : 0
         },
         "RP" : {
            "import_only" : 0
         },
         "SH" : {
            "import_only" : 0
         },
         "SL" : {
            "import_only" : 0
         },
         "SN" : {
            "import_only" : 0
         },
         "ST" : {
            "import_only" : 0
         },
         "TH" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION239" : {
         "BA" : {
            "import_only" : 0
         },
         "BE" : {
            "import_only" : 0
         },
         "BN" : {
            "import_only" : 0
         },
         "BO" : {
            "import_only" : 0
         },
         "BP" : {
            "import_only" : 0
         },
         "CS" : {
            "import_only" : 0
         },
         "FE" : {
            "import_only" : 0
         },
         "GY" : {
            "import_only" : 0
         },
         "HB" : {
            "import_only" : 0
         },
         "HE" : {
            "import_only" : 0
         },
         "KO" : {
            "import_only" : 0
         },
         "NG" : {
            "import_only" : 0
         },
         "PE" : {
            "import_only" : 0
         },
         "SA" : {
            "import_only" : 0
         },
         "SO" : {
            "import_only" : 0
         },
         "SZ" : {
            "import_only" : 0
         },
         "TO" : {
            "import_only" : 0
         },
         "VA" : {
            "import_only" : 0
         },
         "VE" : {
            "import_only" : 0
         },
         "ZA" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION245" : {
         "C" : {
            "import_only" : 1
         },
         "CE" : {
            "import_only" : 0
         },
         "CN" : {
            "import_only" : 0
         },
         "CO" : {
            "import_only" : 0
         },
         "CW" : {
            "import_only" : 0
         },
         "D" : {
            "import_only" : 0
         },
         "DL" : {
            "import_only" : 0
         },
         "G" : {
            "import_only" : 0
         },
         "KE" : {
            "import_only" : 0
         },
         "KK" : {
            "import_only" : 0
         },
         "KY" : {
            "import_only" : 0
         },
         "LD" : {
            "import_only" : 0
         },
         "LH" : {
            "import_only" : 0
         },
         "LK" : {
            "import_only" : 0
         },
         "LM" : {
            "import_only" : 0
         },
         "LS" : {
            "import_only" : 0
         },
         "MH" : {
            "import_only" : 0
         },
         "MN" : {
            "import_only" : 0
         },
         "MO" : {
            "import_only" : 0
         },
         "OY" : {
            "import_only" : 0
         },
         "RN" : {
            "import_only" : 0
         },
         "SO" : {
            "import_only" : 0
         },
         "TA" : {
            "import_only" : 0
         },
         "WD" : {
            "import_only" : 0
         },
         "WH" : {
            "import_only" : 0
         },
         "WW" : {
            "import_only" : 0
         },
         "WX" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION248" : {
         "AG" : {
            "import_only" : 0
         },
         "AL" : {
            "import_only" : 0
         },
         "AN" : {
            "import_only" : 0
         },
         "AO" : {
            "import_only" : 0
         },
         "AP" : {
            "import_only" : 0
         },
         "AQ" : {
            "import_only" : 0
         },
         "AR" : {
            "import_only" : 0
         },
         "AT" : {
            "import_only" : 0
         },
         "AV" : {
            "import_only" : 0
         },
         "BA" : {
            "import_only" : 0
         },
         "BG" : {
            "import_only" : 0
         },
         "BI" : {
            "import_only" : 0
         },
         "BL" : {
            "import_only" : 0
         },
         "BN" : {
            "import_only" : 0
         },
         "BO" : {
            "import_only" : 0
         },
         "BR" : {
            "import_only" : 0
         },
         "BS" : {
            "import_only" : 0
         },
         "BT" : {
            "import_only" : 0
         },
         "BZ" : {
            "import_only" : 0
         },
         "CB" : {
            "import_only" : 0
         },
         "CE" : {
            "import_only" : 0
         },
         "CH" : {
            "import_only" : 0
         },
         "CL" : {
            "import_only" : 0
         },
         "CN" : {
            "import_only" : 0
         },
         "CO" : {
            "import_only" : 0
         },
         "CR" : {
            "import_only" : 0
         },
         "CS" : {
            "import_only" : 0
         },
         "CT" : {
            "import_only" : 0
         },
         "CZ" : {
            "import_only" : 0
         },
         "EN" : {
            "import_only" : 0
         },
         "FC" : {
            "import_only" : 0
         },
         "FE" : {
            "import_only" : 0
         },
         "FG" : {
            "import_only" : 0
         },
         "FI" : {
            "import_only" : 0
         },
         "FM" : {
            "import_only" : 0
         },
         "FO" : {
            "import_only" : 1
         },
         "FR" : {
            "import_only" : 0
         },
         "GE" : {
            "import_only" : 0
         },
         "GO" : {
            "import_only" : 0
         },
         "GR" : {
            "import_only" : 0
         },
         "IM" : {
            "import_only" : 0
         },
         "IS" : {
            "import_only" : 0
         },
         "KR" : {
            "import_only" : 0
         },
         "LC" : {
            "import_only" : 0
         },
         "LE" : {
            "import_only" : 0
         },
         "LI" : {
            "import_only" : 0
         },
         "LO" : {
            "import_only" : 0
         },
         "LT" : {
            "import_only" : 0
         },
         "LU" : {
            "import_only" : 0
         },
         "MB" : {
            "import_only" : 0
         },
         "MC" : {
            "import_only" : 0
         },
         "ME" : {
            "import_only" : 0
         },
         "MI" : {
            "import_only" : 0
         },
         "MN" : {
            "import_only" : 0
         },
         "MO" : {
            "import_only" : 0
         },
         "MS" : {
            "import_only" : 0
         },
         "MT" : {
            "import_only" : 0
         },
         "NA" : {
            "import_only" : 0
         },
         "NO" : {
            "import_only" : 0
         },
         "PA" : {
            "import_only" : 0
         },
         "PC" : {
            "import_only" : 0
         },
         "PD" : {
            "import_only" : 0
         },
         "PE" : {
            "import_only" : 0
         },
         "PG" : {
            "import_only" : 0
         },
         "PI" : {
            "import_only" : 0
         },
         "PN" : {
            "import_only" : 0
         },
         "PO" : {
            "import_only" : 0
         },
         "PR" : {
            "import_only" : 0
         },
         "PS" : {
            "import_only" : 1
         },
         "PT" : {
            "import_only" : 0
         },
         "PU" : {
            "import_only" : 0
         },
         "PV" : {
            "import_only" : 0
         },
         "PZ" : {
            "import_only" : 0
         },
         "RA" : {
            "import_only" : 0
         },
         "RC" : {
            "import_only" : 0
         },
         "RE" : {
            "import_only" : 0
         },
         "RG" : {
            "import_only" : 0
         },
         "RI" : {
            "import_only" : 0
         },
         "RM" : {
            "import_only" : 0
         },
         "RN" : {
            "import_only" : 0
         },
         "RO" : {
            "import_only" : 0
         },
         "SA" : {
            "import_only" : 0
         },
         "SI" : {
            "import_only" : 0
         },
         "SO" : {
            "import_only" : 0
         },
         "SP" : {
            "import_only" : 0
         },
         "SR" : {
            "import_only" : 0
         },
         "SV" : {
            "import_only" : 0
         },
         "TA" : {
            "import_only" : 0
         },
         "TE" : {
            "import_only" : 0
         },
         "TN" : {
            "import_only" : 0
         },
         "TO" : {
            "import_only" : 0
         },
         "TP" : {
            "import_only" : 0
         },
         "TR" : {
            "import_only" : 0
         },
         "TS" : {
            "import_only" : 0
         },
         "TV" : {
            "import_only" : 0
         },
         "UD" : {
            "import_only" : 0
         },
         "VA" : {
            "import_only" : 0
         },
         "VB" : {
            "import_only" : 0
         },
         "VC" : {
            "import_only" : 0
         },
         "VE" : {
            "import_only" : 0
         },
         "VI" : {
            "import_only" : 0
         },
         "VR" : {
            "import_only" : 0
         },
         "VT" : {
            "import_only" : 0
         },
         "VV" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION256" : {
         "MD" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION259" : {
         "21" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION263" : {
         "DR" : {
            "import_only" : 0
         },
         "FL" : {
            "import_only" : 0
         },
         "FR" : {
            "import_only" : 0
         },
         "GD" : {
            "import_only" : 1
         },
         "GE" : {
            "import_only" : 0
         },
         "GR" : {
            "import_only" : 0
         },
         "LB" : {
            "import_only" : 1
         },
         "LI" : {
            "import_only" : 0
         },
         "NB" : {
            "import_only" : 0
         },
         "NH" : {
            "import_only" : 0
         },
         "OV" : {
            "import_only" : 0
         },
         "UT" : {
            "import_only" : 0
         },
         "ZE" : {
            "import_only" : 0
         },
         "ZH" : {
            "import_only" : 0
         },
         "ZL" : {
            "import_only" : 1
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION266" : {
         "03" : {
            "import_only" : 0
         },
         "11" : {
            "import_only" : 0
         },
         "15" : {
            "import_only" : 0
         },
         "18" : {
            "import_only" : 0
         },
         "30" : {
            "import_only" : 0
         },
         "34" : {
            "import_only" : 0
         },
         "38" : {
            "import_only" : 0
         },
         "42" : {
            "import_only" : 0
         },
         "46" : {
            "import_only" : 0
         },
         "50" : {
            "import_only" : 0
         },
         "54" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION269" : {
         "B" : {
            "import_only" : 0
         },
         "C" : {
            "import_only" : 0
         },
         "D" : {
            "import_only" : 0
         },
         "F" : {
            "import_only" : 0
         },
         "G" : {
            "import_only" : 0
         },
         "J" : {
            "import_only" : 0
         },
         "K" : {
            "import_only" : 0
         },
         "L" : {
            "import_only" : 0
         },
         "M" : {
            "import_only" : 0
         },
         "O" : {
            "import_only" : 0
         },
         "P" : {
            "import_only" : 0
         },
         "R" : {
            "import_only" : 0
         },
         "S" : {
            "import_only" : 0
         },
         "U" : {
            "import_only" : 0
         },
         "W" : {
            "import_only" : 0
         },
         "Z" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION27" : {
         "BR" : {
            "import_only" : 0
         },
         "HM" : {
            "import_only" : 0
         },
         "HO" : {
            "import_only" : 0
         },
         "HR" : {
            "import_only" : 0
         },
         "MA" : {
            "import_only" : 0
         },
         "MI" : {
            "import_only" : 0
         },
         "VI" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION272" : {
         "AV" : {
            "import_only" : 0
         },
         "BG" : {
            "import_only" : 0
         },
         "BJ" : {
            "import_only" : 0
         },
         "BR" : {
            "import_only" : 0
         },
         "CB" : {
            "import_only" : 0
         },
         "CO" : {
            "import_only" : 0
         },
         "EV" : {
            "import_only" : 0
         },
         "FR" : {
            "import_only" : 0
         },
         "GD" : {
            "import_only" : 0
         },
         "LR" : {
            "import_only" : 0
         },
         "LX" : {
            "import_only" : 0
         },
         "PG" : {
            "import_only" : 0
         },
         "PT" : {
            "import_only" : 0
         },
         "SR" : {
            "import_only" : 0
         },
         "ST" : {
            "import_only" : 0
         },
         "VC" : {
            "import_only" : 0
         },
         "VR" : {
            "import_only" : 0
         },
         "VS" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION275" : {
         "AB" : {
            "import_only" : 0
         },
         "AG" : {
            "import_only" : 0
         },
         "AR" : {
            "import_only" : 0
         },
         "B" : {
            "import_only" : 0
         },
         "BC" : {
            "import_only" : 0
         },
         "BH" : {
            "import_only" : 0
         },
         "BN" : {
            "import_only" : 0
         },
         "BR" : {
            "import_only" : 0
         },
         "BT" : {
            "import_only" : 0
         },
         "BU" : {
            "import_only" : 1
         },
         "BV" : {
            "import_only" : 0
         },
         "BZ" : {
            "import_only" : 0
         },
         "CJ" : {
            "import_only" : 0
         },
         "CL" : {
            "import_only" : 0
         },
         "CS" : {
            "import_only" : 0
         },
         "CT" : {
            "import_only" : 0
         },
         "CV" : {
            "import_only" : 0
         },
         "DB" : {
            "import_only" : 0
         },
         "DJ" : {
            "import_only" : 0
         },
         "GJ" : {
            "import_only" : 0
         },
         "GL" : {
            "import_only" : 0
         },
         "GR" : {
            "import_only" : 0
         },
         "HD" : {
            "import_only" : 0
         },
         "HR" : {
            "import_only" : 0
         },
         "IF" : {
            "import_only" : 0
         },
         "IL" : {
            "import_only" : 0
         },
         "IS" : {
            "import_only" : 0
         },
         "MH" : {
            "import_only" : 0
         },
         "MM" : {
            "import_only" : 0
         },
         "MS" : {
            "import_only" : 0
         },
         "NT" : {
            "import_only" : 0
         },
         "OT" : {
            "import_only" : 0
         },
         "PH" : {
            "import_only" : 0
         },
         "SB" : {
            "import_only" : 0
         },
         "SJ" : {
            "import_only" : 0
         },
         "SM" : {
            "import_only" : 0
         },
         "SV" : {
            "import_only" : 0
         },
         "TL" : {
            "import_only" : 0
         },
         "TM" : {
            "import_only" : 0
         },
         "TR" : {
            "import_only" : 0
         },
         "VL" : {
            "import_only" : 0
         },
         "VN" : {
            "import_only" : 0
         },
         "VS" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION281" : {
         "A" : {
            "import_only" : 0
         },
         "AB" : {
            "import_only" : 0
         },
         "AL" : {
            "import_only" : 0
         },
         "AV" : {
            "import_only" : 0
         },
         "B" : {
            "import_only" : 0
         },
         "BA" : {
            "import_only" : 0
         },
         "BI" : {
            "import_only" : 0
         },
         "BU" : {
            "import_only" : 0
         },
         "C" : {
            "import_only" : 0
         },
         "CA" : {
            "import_only" : 0
         },
         "CC" : {
            "import_only" : 0
         },
         "CO" : {
            "import_only" : 0
         },
         "CR" : {
            "import_only" : 0
         },
         "CS" : {
            "import_only" : 0
         },
         "CU" : {
            "import_only" : 0
         },
         "GI" : {
            "import_only" : 0
         },
         "GR" : {
            "import_only" : 0
         },
         "GU" : {
            "import_only" : 0
         },
         "H" : {
            "import_only" : 0
         },
         "HU" : {
            "import_only" : 0
         },
         "J" : {
            "import_only" : 0
         },
         "L" : {
            "import_only" : 0
         },
         "LE" : {
            "import_only" : 0
         },
         "LO" : {
            "import_only" : 0
         },
         "LU" : {
            "import_only" : 0
         },
         "M" : {
            "import_only" : 0
         },
         "MA" : {
            "import_only" : 0
         },
         "MU" : {
            "import_only" : 0
         },
         "NA" : {
            "import_only" : 0
         },
         "O" : {
            "import_only" : 0
         },
         "OR" : {
            "import_only" : 0
         },
         "OU" : {
            "import_only" : 1
         },
         "P" : {
            "import_only" : 0
         },
         "PO" : {
            "import_only" : 0
         },
         "S" : {
            "import_only" : 0
         },
         "SA" : {
            "import_only" : 0
         },
         "SE" : {
            "import_only" : 0
         },
         "SG" : {
            "import_only" : 0
         },
         "SO" : {
            "import_only" : 0
         },
         "SS" : {
            "import_only" : 0
         },
         "T" : {
            "import_only" : 0
         },
         "TE" : {
            "import_only" : 0
         },
         "TO" : {
            "import_only" : 0
         },
         "V" : {
            "import_only" : 0
         },
         "VA" : {
            "import_only" : 0
         },
         "VI" : {
            "import_only" : 0
         },
         "Z" : {
            "import_only" : 0
         },
         "ZA" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION284" : {
         "AB" : {
            "import_only" : 0
         },
         "AC" : {
            "import_only" : 0
         },
         "BD" : {
            "import_only" : 0
         },
         "C" : {
            "import_only" : 0
         },
         "D" : {
            "import_only" : 0
         },
         "E" : {
            "import_only" : 0
         },
         "F" : {
            "import_only" : 0
         },
         "G" : {
            "import_only" : 0
         },
         "H" : {
            "import_only" : 0
         },
         "I" : {
            "import_only" : 0
         },
         "K" : {
            "import_only" : 0
         },
         "M" : {
            "import_only" : 0
         },
         "N" : {
            "import_only" : 0
         },
         "O" : {
            "import_only" : 0
         },
         "S" : {
            "import_only" : 0
         },
         "T" : {
            "import_only" : 0
         },
         "U" : {
            "import_only" : 0
         },
         "W" : {
            "import_only" : 0
         },
         "X" : {
            "import_only" : 0
         },
         "Y" : {
            "import_only" : 0
         },
         "Z" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION287" : {
         "AG" : {
            "import_only" : 0
         },
         "AI" : {
            "import_only" : 0
         },
         "AR" : {
            "import_only" : 0
         },
         "BE" : {
            "import_only" : 0
         },
         "BL" : {
            "import_only" : 0
         },
         "BS" : {
            "import_only" : 0
         },
         "FR" : {
            "import_only" : 0
         },
         "GE" : {
            "import_only" : 0
         },
         "GL" : {
            "import_only" : 0
         },
         "GR" : {
            "import_only" : 0
         },
         "JU" : {
            "import_only" : 0
         },
         "LU" : {
            "import_only" : 0
         },
         "NE" : {
            "import_only" : 0
         },
         "NW" : {
            "import_only" : 0
         },
         "OW" : {
            "import_only" : 0
         },
         "SG" : {
            "import_only" : 0
         },
         "SH" : {
            "import_only" : 0
         },
         "SO" : {
            "import_only" : 0
         },
         "SZ" : {
            "import_only" : 0
         },
         "TG" : {
            "import_only" : 0
         },
         "TI" : {
            "import_only" : 0
         },
         "UR" : {
            "import_only" : 0
         },
         "VD" : {
            "import_only" : 0
         },
         "VS" : {
            "import_only" : 0
         },
         "ZG" : {
            "import_only" : 0
         },
         "ZH" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION288" : {
         "CH" : {
            "import_only" : 0
         },
         "CN" : {
            "import_only" : 0
         },
         "CR" : {
            "import_only" : 0
         },
         "DN" : {
            "import_only" : 0
         },
         "DO" : {
            "import_only" : 0
         },
         "HA" : {
            "import_only" : 0
         },
         "HE" : {
            "import_only" : 0
         },
         "HM" : {
            "import_only" : 0
         },
         "IF" : {
            "import_only" : 0
         },
         "KI" : {
            "import_only" : 0
         },
         "KO" : {
            "import_only" : 0
         },
         "KR" : {
            "import_only" : 0
         },
         "KV" : {
            "import_only" : 0
         },
         "LU" : {
            "import_only" : 0
         },
         "LV" : {
            "import_only" : 0
         },
         "NI" : {
            "import_only" : 0
         },
         "OD" : {
            "import_only" : 0
         },
         "PO" : {
            "import_only" : 0
         },
         "RI" : {
            "import_only" : 0
         },
         "SL" : {
            "import_only" : 0
         },
         "SU" : {
            "import_only" : 0
         },
         "TE" : {
            "import_only" : 0
         },
         "VI" : {
            "import_only" : 0
         },
         "VO" : {
            "import_only" : 0
         },
         "ZA" : {
            "import_only" : 0
         },
         "ZH" : {
            "import_only" : 0
         },
         "ZP" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION29" : {
         "GC" : {
            "import_only" : 0
         },
         "TF" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION291" : {
         "AL" : {
            "import_only" : 0
         },
         "AR" : {
            "import_only" : 0
         },
         "AZ" : {
            "import_only" : 0
         },
         "CA" : {
            "import_only" : 0
         },
         "CO" : {
            "import_only" : 0
         },
         "CT" : {
            "import_only" : 0
         },
         "DC" : {
            "import_only" : 0
         },
         "DE" : {
            "import_only" : 0
         },
         "FL" : {
            "import_only" : 0
         },
         "GA" : {
            "import_only" : 0
         },
         "IA" : {
            "import_only" : 0
         },
         "ID" : {
            "import_only" : 0
         },
         "IL" : {
            "import_only" : 0
         },
         "IN" : {
            "import_only" : 0
         },
         "KS" : {
            "import_only" : 0
         },
         "KY" : {
            "import_only" : 0
         },
         "LA" : {
            "import_only" : 0
         },
         "MA" : {
            "import_only" : 0
         },
         "MD" : {
            "import_only" : 0
         },
         "ME" : {
            "import_only" : 0
         },
         "MI" : {
            "import_only" : 0
         },
         "MN" : {
            "import_only" : 0
         },
         "MO" : {
            "import_only" : 0
         },
         "MS" : {
            "import_only" : 0
         },
         "MT" : {
            "import_only" : 0
         },
         "NC" : {
            "import_only" : 0
         },
         "ND" : {
            "import_only" : 0
         },
         "NE" : {
            "import_only" : 0
         },
         "NH" : {
            "import_only" : 0
         },
         "NJ" : {
            "import_only" : 0
         },
         "NM" : {
            "import_only" : 0
         },
         "NV" : {
            "import_only" : 0
         },
         "NY" : {
            "import_only" : 0
         },
         "OH" : {
            "import_only" : 0
         },
         "OK" : {
            "import_only" : 0
         },
         "OR" : {
            "import_only" : 0
         },
         "PA" : {
            "import_only" : 0
         },
         "RI" : {
            "import_only" : 0
         },
         "SC" : {
            "import_only" : 0
         },
         "SD" : {
            "import_only" : 0
         },
         "TN" : {
            "import_only" : 0
         },
         "TX" : {
            "import_only" : 0
         },
         "UT" : {
            "import_only" : 0
         },
         "VA" : {
            "import_only" : 0
         },
         "VT" : {
            "import_only" : 0
         },
         "WA" : {
            "import_only" : 0
         },
         "WI" : {
            "import_only" : 0
         },
         "WV" : {
            "import_only" : 0
         },
         "WY" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION318" : {
         "AH" : {
            "import_only" : 0
         },
         "BJ" : {
            "import_only" : 0
         },
         "CQ" : {
            "import_only" : 0
         },
         "FJ" : {
            "import_only" : 0
         },
         "GD" : {
            "import_only" : 0
         },
         "GS" : {
            "import_only" : 0
         },
         "GX" : {
            "import_only" : 0
         },
         "GZ" : {
            "import_only" : 0
         },
         "HA" : {
            "import_only" : 0
         },
         "HB" : {
            "import_only" : 0
         },
         "HE" : {
            "import_only" : 0
         },
         "HI" : {
            "import_only" : 0
         },
         "HL" : {
            "import_only" : 0
         },
         "HN" : {
            "import_only" : 0
         },
         "JL" : {
            "import_only" : 0
         },
         "JS" : {
            "import_only" : 0
         },
         "JX" : {
            "import_only" : 0
         },
         "LN" : {
            "import_only" : 0
         },
         "NM" : {
            "import_only" : 0
         },
         "NX" : {
            "import_only" : 0
         },
         "QH" : {
            "import_only" : 0
         },
         "SC" : {
            "import_only" : 0
         },
         "SD" : {
            "import_only" : 0
         },
         "SH" : {
            "import_only" : 0
         },
         "SN" : {
            "import_only" : 0
         },
         "SX" : {
            "import_only" : 0
         },
         "TJ" : {
            "import_only" : 0
         },
         "XJ" : {
            "import_only" : 0
         },
         "XZ" : {
            "import_only" : 0
         },
         "YN" : {
            "import_only" : 0
         },
         "ZJ" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION32" : {
         "CE" : {
            "import_only" : 0
         },
         "ML" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION324" : {
         "AP" : {
            "import_only" : 0
         },
         "AR" : {
            "import_only" : 0
         },
         "AS" : {
            "import_only" : 0
         },
         "BR" : {
            "import_only" : 0
         },
         "CG" : {
            "import_only" : 0
         },
         "CH" : {
            "import_only" : 0
         },
         "DD" : {
            "import_only" : 0
         },
         "DL" : {
            "import_only" : 0
         },
         "DN" : {
            "import_only" : 0
         },
         "GA" : {
            "import_only" : 0
         },
         "GJ" : {
            "import_only" : 0
         },
         "HP" : {
            "import_only" : 0
         },
         "HR" : {
            "import_only" : 0
         },
         "JH" : {
            "import_only" : 0
         },
         "JK" : {
            "import_only" : 0
         },
         "KA" : {
            "import_only" : 0
         },
         "KL" : {
            "import_only" : 0
         },
         "LA" : {
            "import_only" : 0
         },
         "MH" : {
            "import_only" : 0
         },
         "ML" : {
            "import_only" : 0
         },
         "MN" : {
            "import_only" : 0
         },
         "MP" : {
            "import_only" : 0
         },
         "MZ" : {
            "import_only" : 0
         },
         "NL" : {
            "import_only" : 0
         },
         "OD" : {
            "import_only" : 0
         },
         "PB" : {
            "import_only" : 0
         },
         "PY" : {
            "import_only" : 0
         },
         "RJ" : {
            "import_only" : 0
         },
         "SK" : {
            "import_only" : 0
         },
         "TG" : {
            "import_only" : 0
         },
         "TN" : {
            "import_only" : 0
         },
         "TR" : {
            "import_only" : 0
         },
         "UK" : {
            "import_only" : 0
         },
         "UP" : {
            "import_only" : 0
         },
         "WB" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION339" : {
         "01" : {
            "import_only" : 0
         },
         "02" : {
            "import_only" : 0
         },
         "03" : {
            "import_only" : 0
         },
         "04" : {
            "import_only" : 0
         },
         "05" : {
            "import_only" : 0
         },
         "06" : {
            "import_only" : 0
         },
         "07" : {
            "import_only" : 0
         },
         "08" : {
            "import_only" : 0
         },
         "09" : {
            "import_only" : 0
         },
         "10" : {
            "import_only" : 0
         },
         "11" : {
            "import_only" : 0
         },
         "12" : {
            "import_only" : 0
         },
         "13" : {
            "import_only" : 0
         },
         "14" : {
            "import_only" : 0
         },
         "15" : {
            "import_only" : 0
         },
         "16" : {
            "import_only" : 0
         },
         "17" : {
            "import_only" : 0
         },
         "18" : {
            "import_only" : 0
         },
         "19" : {
            "import_only" : 0
         },
         "20" : {
            "import_only" : 0
         },
         "21" : {
            "import_only" : 0
         },
         "22" : {
            "import_only" : 0
         },
         "23" : {
            "import_only" : 0
         },
         "24" : {
            "import_only" : 0
         },
         "25" : {
            "import_only" : 0
         },
         "26" : {
            "import_only" : 0
         },
         "27" : {
            "import_only" : 0
         },
         "28" : {
            "import_only" : 0
         },
         "29" : {
            "import_only" : 0
         },
         "30" : {
            "import_only" : 0
         },
         "31" : {
            "import_only" : 0
         },
         "32" : {
            "import_only" : 0
         },
         "33" : {
            "import_only" : 0
         },
         "34" : {
            "import_only" : 0
         },
         "35" : {
            "import_only" : 0
         },
         "36" : {
            "import_only" : 0
         },
         "37" : {
            "import_only" : 0
         },
         "38" : {
            "import_only" : 0
         },
         "39" : {
            "import_only" : 0
         },
         "40" : {
            "import_only" : 0
         },
         "41" : {
            "import_only" : 0
         },
         "42" : {
            "import_only" : 0
         },
         "43" : {
            "import_only" : 0
         },
         "44" : {
            "import_only" : 0
         },
         "45" : {
            "import_only" : 0
         },
         "46" : {
            "import_only" : 0
         },
         "47" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION375" : {
         "ABR" : {
            "import_only" : 0
         },
         "AGN" : {
            "import_only" : 0
         },
         "AGS" : {
            "import_only" : 0
         },
         "AKL" : {
            "import_only" : 0
         },
         "ALB" : {
            "import_only" : 0
         },
         "ANT" : {
            "import_only" : 0
         },
         "APA" : {
            "import_only" : 0
         },
         "AUR" : {
            "import_only" : 0
         },
         "BAN" : {
            "import_only" : 0
         },
         "BAS" : {
            "import_only" : 0
         },
         "BEN" : {
            "import_only" : 0
         },
         "BIL" : {
            "import_only" : 0
         },
         "BOH" : {
            "import_only" : 0
         },
         "BTG" : {
            "import_only" : 0
         },
         "BTN" : {
            "import_only" : 0
         },
         "BUK" : {
            "import_only" : 0
         },
         "BUL" : {
            "import_only" : 0
         },
         "CAG" : {
            "import_only" : 0
         },
         "CAM" : {
            "import_only" : 0
         },
         "CAN" : {
            "import_only" : 0
         },
         "CAP" : {
            "import_only" : 0
         },
         "CAS" : {
            "import_only" : 0
         },
         "CAT" : {
            "import_only" : 0
         },
         "CAV" : {
            "import_only" : 0
         },
         "CEB" : {
            "import_only" : 0
         },
         "COM" : {
            "import_only" : 0
         },
         "DAO" : {
            "import_only" : 0
         },
         "DAS" : {
            "import_only" : 0
         },
         "DAV" : {
            "import_only" : 0
         },
         "EAS" : {
            "import_only" : 0
         },
         "GUI" : {
            "import_only" : 0
         },
         "IFU" : {
            "import_only" : 0
         },
         "ILI" : {
            "import_only" : 0
         },
         "ILN" : {
            "import_only" : 0
         },
         "ILS" : {
            "import_only" : 0
         },
         "ISA" : {
            "import_only" : 0
         },
         "KAL" : {
            "import_only" : 0
         },
         "LAG" : {
            "import_only" : 0
         },
         "LAN" : {
            "import_only" : 0
         },
         "LAS" : {
            "import_only" : 0
         },
         "LEY" : {
            "import_only" : 0
         },
         "LUN" : {
            "import_only" : 0
         },
         "MAD" : {
            "import_only" : 0
         },
         "MAG" : {
            "import_only" : 0
         },
         "MAS" : {
            "import_only" : 0
         },
         "MDC" : {
            "import_only" : 0
         },
         "MDR" : {
            "import_only" : 0
         },
         "MOU" : {
            "import_only" : 0
         },
         "MSC" : {
            "import_only" : 0
         },
         "MSR" : {
            "import_only" : 0
         },
         "NCO" : {
            "import_only" : 0
         },
         "NEC" : {
            "import_only" : 0
         },
         "NER" : {
            "import_only" : 0
         },
         "NSA" : {
            "import_only" : 0
         },
         "NUE" : {
            "import_only" : 0
         },
         "NUV" : {
            "import_only" : 0
         },
         "PAM" : {
            "import_only" : 0
         },
         "PAN" : {
            "import_only" : 0
         },
         "PLW" : {
            "import_only" : 0
         },
         "QUE" : {
            "import_only" : 0
         },
         "QUI" : {
            "import_only" : 0
         },
         "RIZ" : {
            "import_only" : 0
         },
         "ROM" : {
            "import_only" : 0
         },
         "SAR" : {
            "import_only" : 0
         },
         "SCO" : {
            "import_only" : 0
         },
         "SIG" : {
            "import_only" : 0
         },
         "SLE" : {
            "import_only" : 0
         },
         "SLU" : {
            "import_only" : 0
         },
         "SOR" : {
            "import_only" : 0
         },
         "SUK" : {
            "import_only" : 0
         },
         "SUN" : {
            "import_only" : 0
         },
         "SUR" : {
            "import_only" : 0
         },
         "TAR" : {
            "import_only" : 0
         },
         "TAW" : {
            "import_only" : 0
         },
         "WSA" : {
            "import_only" : 0
         },
         "ZAN" : {
            "import_only" : 0
         },
         "ZAS" : {
            "import_only" : 0
         },
         "ZMB" : {
            "import_only" : 0
         },
         "ZSI" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION386" : {
         "CHA" : {
            "import_only" : 0
         },
         "CYI" : {
            "import_only" : 0
         },
         "CYQ" : {
            "import_only" : 0
         },
         "HSQ" : {
            "import_only" : 0
         },
         "HSZ" : {
            "import_only" : 0
         },
         "HUA" : {
            "import_only" : 0
         },
         "ILA" : {
            "import_only" : 0
         },
         "KEE" : {
            "import_only" : 0
         },
         "KHH" : {
            "import_only" : 0
         },
         "KIN" : {
            "import_only" : 0
         },
         "LIE" : {
            "import_only" : 0
         },
         "MIA" : {
            "import_only" : 0
         },
         "NAN" : {
            "import_only" : 0
         },
         "NWT" : {
            "import_only" : 0
         },
         "PEN" : {
            "import_only" : 0
         },
         "PIF" : {
            "import_only" : 0
         },
         "TAO" : {
            "import_only" : 0
         },
         "TNN" : {
            "import_only" : 0
         },
         "TPE" : {
            "import_only" : 0
         },
         "TTT" : {
            "import_only" : 0
         },
         "TXG" : {
            "import_only" : 0
         },
         "YUN" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION497" : {
         "01" : {
            "import_only" : 0
         },
         "02" : {
            "import_only" : 0
         },
         "03" : {
            "import_only" : 0
         },
         "04" : {
            "import_only" : 0
         },
         "05" : {
            "import_only" : 0
         },
         "06" : {
            "import_only" : 0
         },
         "07" : {
            "import_only" : 0
         },
         "08" : {
            "import_only" : 0
         },
         "09" : {
            "import_only" : 0
         },
         "10" : {
            "import_only" : 0
         },
         "11" : {
            "import_only" : 0
         },
         "12" : {
            "import_only" : 0
         },
         "13" : {
            "import_only" : 0
         },
         "14" : {
            "import_only" : 0
         },
         "15" : {
            "import_only" : 0
         },
         "16" : {
            "import_only" : 0
         },
         "17" : {
            "import_only" : 0
         },
         "18" : {
            "import_only" : 0
         },
         "19" : {
            "import_only" : 0
         },
         "20" : {
            "import_only" : 0
         },
         "21" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION5" : {
         "001" : {
            "import_only" : 0
         },
         "002" : {
            "import_only" : 0
         },
         "003" : {
            "import_only" : 0
         },
         "004" : {
            "import_only" : 0
         },
         "005" : {
            "import_only" : 0
         },
         "006" : {
            "import_only" : 0
         },
         "007" : {
            "import_only" : 0
         },
         "008" : {
            "import_only" : 0
         },
         "009" : {
            "import_only" : 0
         },
         "010" : {
            "import_only" : 0
         },
         "011" : {
            "import_only" : 0
         },
         "012" : {
            "import_only" : 0
         },
         "013" : {
            "import_only" : 0
         },
         "014" : {
            "import_only" : 0
         },
         "015" : {
            "import_only" : 0
         },
         "016" : {
            "import_only" : 0
         },
         "051" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION50" : {
         "AGS" : {
            "import_only" : 1
         },
         "AGU" : {
            "import_only" : 0
         },
         "BC" : {
            "import_only" : 1
         },
         "BCN" : {
            "import_only" : 0
         },
         "BCS" : {
            "import_only" : 0
         },
         "CAM" : {
            "import_only" : 0
         },
         "CHH" : {
            "import_only" : 0
         },
         "CHP" : {
            "import_only" : 0
         },
         "CHS" : {
            "import_only" : 1
         },
         "CMX" : {
            "import_only" : 0
         },
         "COA" : {
            "import_only" : 0
         },
         "COL" : {
            "import_only" : 0
         },
         "DF" : {
            "import_only" : 1
         },
         "DGO" : {
            "import_only" : 1
         },
         "DUR" : {
            "import_only" : 0
         },
         "EMX" : {
            "import_only" : 1
         },
         "GRO" : {
            "import_only" : 0
         },
         "GTO" : {
            "import_only" : 1
         },
         "GUA" : {
            "import_only" : 0
         },
         "HGO" : {
            "import_only" : 1
         },
         "HID" : {
            "import_only" : 0
         },
         "JAL" : {
            "import_only" : 0
         },
         "MEX" : {
            "import_only" : 0
         },
         "MIC" : {
            "import_only" : 0
         },
         "MOR" : {
            "import_only" : 0
         },
         "NAY" : {
            "import_only" : 0
         },
         "NL" : {
            "import_only" : 1
         },
         "NLE" : {
            "import_only" : 0
         },
         "OAX" : {
            "import_only" : 0
         },
         "PUE" : {
            "import_only" : 0
         },
         "QRO" : {
            "import_only" : 1
         },
         "QTR" : {
            "import_only" : 1
         },
         "QUE" : {
            "import_only" : 0
         },
         "ROO" : {
            "import_only" : 0
         },
         "SIN" : {
            "import_only" : 0
         },
         "SLP" : {
            "import_only" : 0
         },
         "SON" : {
            "import_only" : 0
         },
         "TAB" : {
            "import_only" : 0
         },
         "TAM" : {
            "import_only" : 0
         },
         "TLA" : {
            "import_only" : 0
         },
         "TLX" : {
            "import_only" : 1
         },
         "TMS" : {
            "import_only" : 1
         },
         "VER" : {
            "import_only" : 0
         },
         "YUC" : {
            "import_only" : 0
         },
         "ZAC" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION503" : {
         "APA" : {
            "import_only" : 0
         },
         "APB" : {
            "import_only" : 0
         },
         "APC" : {
            "import_only" : 0
         },
         "APD" : {
            "import_only" : 0
         },
         "APE" : {
            "import_only" : 0
         },
         "APF" : {
            "import_only" : 0
         },
         "APG" : {
            "import_only" : 0
         },
         "APH" : {
            "import_only" : 0
         },
         "API" : {
            "import_only" : 0
         },
         "APJ" : {
            "import_only" : 0
         },
         "BBE" : {
            "import_only" : 0
         },
         "BBN" : {
            "import_only" : 0
         },
         "BKD" : {
            "import_only" : 0
         },
         "BKH" : {
            "import_only" : 0
         },
         "BKO" : {
            "import_only" : 0
         },
         "BMB" : {
            "import_only" : 0
         },
         "BME" : {
            "import_only" : 0
         },
         "BNY" : {
            "import_only" : 0
         },
         "BPB" : {
            "import_only" : 0
         },
         "BPV" : {
            "import_only" : 0
         },
         "BPZ" : {
            "import_only" : 0
         },
         "BRA" : {
            "import_only" : 0
         },
         "CBU" : {
            "import_only" : 0
         },
         "CCK" : {
            "import_only" : 0
         },
         "CJH" : {
            "import_only" : 0
         },
         "CPE" : {
            "import_only" : 0
         },
         "CPI" : {
            "import_only" : 0
         },
         "CPR" : {
            "import_only" : 0
         },
         "CST" : {
            "import_only" : 0
         },
         "CTA" : {
            "import_only" : 0
         },
         "DCH" : {
            "import_only" : 0
         },
         "DDO" : {
            "import_only" : 0
         },
         "DKL" : {
            "import_only" : 0
         },
         "DKV" : {
            "import_only" : 0
         },
         "DPJ" : {
            "import_only" : 0
         },
         "DPM" : {
            "import_only" : 0
         },
         "DPS" : {
            "import_only" : 0
         },
         "DRO" : {
            "import_only" : 0
         },
         "DSO" : {
            "import_only" : 0
         },
         "DTA" : {
            "import_only" : 0
         },
         "ECH" : {
            "import_only" : 0
         },
         "ECL" : {
            "import_only" : 0
         },
         "EDE" : {
            "import_only" : 0
         },
         "EJA" : {
            "import_only" : 0
         },
         "ELI" : {
            "import_only" : 0
         },
         "ELO" : {
            "import_only" : 0
         },
         "ELT" : {
            "import_only" : 0
         },
         "EMO" : {
            "import_only" : 0
         },
         "ETE" : {
            "import_only" : 0
         },
         "EUL" : {
            "import_only" : 0
         },
         "FCR" : {
            "import_only" : 0
         },
         "FHB" : {
            "import_only" : 0
         },
         "FHK" : {
            "import_only" : 0
         },
         "FJI" : {
            "import_only" : 0
         },
         "FNA" : {
            "import_only" : 0
         },
         "FPA" : {
            "import_only" : 0
         },
         "FRK" : {
            "import_only" : 0
         },
         "FSE" : {
            "import_only" : 0
         },
         "FSV" : {
            "import_only" : 0
         },
         "FTR" : {
            "import_only" : 0
         },
         "FUO" : {
            "import_only" : 0
         },
         "GBL" : {
            "import_only" : 0
         },
         "GBM" : {
            "import_only" : 0
         },
         "GBR" : {
            "import_only" : 0
         },
         "GBV" : {
            "import_only" : 0
         },
         "GHO" : {
            "import_only" : 0
         },
         "GJI" : {
            "import_only" : 0
         },
         "GKR" : {
            "import_only" : 0
         },
         "GPR" : {
            "import_only" : 0
         },
         "GTR" : {
            "import_only" : 0
         },
         "GUH" : {
            "import_only" : 0
         },
         "GVY" : {
            "import_only" : 0
         },
         "GZL" : {
            "import_only" : 0
         },
         "GZN" : {
            "import_only" : 0
         },
         "GZS" : {
            "import_only" : 0
         },
         "HBR" : {
            "import_only" : 0
         },
         "HFM" : {
            "import_only" : 0
         },
         "HJE" : {
            "import_only" : 0
         },
         "HKA" : {
            "import_only" : 0
         },
         "HNJ" : {
            "import_only" : 0
         },
         "HOL" : {
            "import_only" : 0
         },
         "HOP" : {
            "import_only" : 0
         },
         "HOS" : {
            "import_only" : 0
         },
         "HPR" : {
            "import_only" : 0
         },
         "HSU" : {
            "import_only" : 0
         },
         "HVS" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION504" : {
         "BAA" : {
            "import_only" : 0
         },
         "BAB" : {
            "import_only" : 0
         },
         "BAC" : {
            "import_only" : 0
         },
         "BAD" : {
            "import_only" : 0
         },
         "BAE" : {
            "import_only" : 0
         },
         "BAN" : {
            "import_only" : 0
         },
         "BAR" : {
            "import_only" : 0
         },
         "BBY" : {
            "import_only" : 0
         },
         "BRE" : {
            "import_only" : 0
         },
         "BST" : {
            "import_only" : 0
         },
         "BYT" : {
            "import_only" : 0
         },
         "CAD" : {
            "import_only" : 0
         },
         "DET" : {
            "import_only" : 0
         },
         "DKU" : {
            "import_only" : 0
         },
         "DST" : {
            "import_only" : 0
         },
         "GAL" : {
            "import_only" : 0
         },
         "GEL" : {
            "import_only" : 0
         },
         "HLO" : {
            "import_only" : 0
         },
         "HUM" : {
            "import_only" : 0
         },
         "ILA" : {
            "import_only" : 0
         },
         "KEA" : {
            "import_only" : 0
         },
         "KEB" : {
            "import_only" : 0
         },
         "KEC" : {
            "import_only" : 0
         },
         "KED" : {
            "import_only" : 0
         },
         "KEO" : {
            "import_only" : 0
         },
         "KEZ" : {
            "import_only" : 0
         },
         "KNM" : {
            "import_only" : 0
         },
         "KOM" : {
            "import_only" : 0
         },
         "KRU" : {
            "import_only" : 0
         },
         "LEV" : {
            "import_only" : 0
         },
         "LMI" : {
            "import_only" : 0
         },
         "LUC" : {
            "import_only" : 0
         },
         "LVC" : {
            "import_only" : 0
         },
         "MAL" : {
            "import_only" : 0
         },
         "MAR" : {
            "import_only" : 0
         },
         "MED" : {
            "import_only" : 0
         },
         "MIC" : {
            "import_only" : 0
         },
         "MYJ" : {
            "import_only" : 0
         },
         "NAM" : {
            "import_only" : 0
         },
         "NIT" : {
            "import_only" : 0
         },
         "NMV" : {
            "import_only" : 0
         },
         "NZA" : {
            "import_only" : 0
         },
         "PAR" : {
            "import_only" : 0
         },
         "PBY" : {
            "import_only" : 0
         },
         "PEZ" : {
            "import_only" : 0
         },
         "PIE" : {
            "import_only" : 0
         },
         "POL" : {
            "import_only" : 0
         },
         "POP" : {
            "import_only" : 0
         },
         "PRE" : {
            "import_only" : 0
         },
         "PRI" : {
            "import_only" : 0
         },
         "PUC" : {
            "import_only" : 0
         },
         "REV" : {
            "import_only" : 0
         },
         "ROZ" : {
            "import_only" : 0
         },
         "RSO" : {
            "import_only" : 0
         },
         "RUZ" : {
            "import_only" : 0
         },
         "SAB" : {
            "import_only" : 0
         },
         "SAL" : {
            "import_only" : 0
         },
         "SEA" : {
            "import_only" : 0
         },
         "SEN" : {
            "import_only" : 0
         },
         "SKA" : {
            "import_only" : 0
         },
         "SLU" : {
            "import_only" : 0
         },
         "SNI" : {
            "import_only" : 0
         },
         "SNV" : {
            "import_only" : 0
         },
         "SOB" : {
            "import_only" : 0
         },
         "STR" : {
            "import_only" : 0
         },
         "SVI" : {
            "import_only" : 0
         },
         "TNC" : {
            "import_only" : 0
         },
         "TOP" : {
            "import_only" : 0
         },
         "TRE" : {
            "import_only" : 0
         },
         "TRN" : {
            "import_only" : 0
         },
         "TTE" : {
            "import_only" : 0
         },
         "TVR" : {
            "import_only" : 0
         },
         "VKR" : {
            "import_only" : 0
         },
         "VRT" : {
            "import_only" : 0
         },
         "ZAR" : {
            "import_only" : 0
         },
         "ZIH" : {
            "import_only" : 0
         },
         "ZIL" : {
            "import_only" : 0
         },
         "ZMO" : {
            "import_only" : 0
         },
         "ZVO" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION54" : {
         "AD" : {
            "import_only" : 0
         },
         "AO" : {
            "import_only" : 0
         },
         "AR" : {
            "import_only" : 0
         },
         "BO" : {
            "import_only" : 0
         },
         "BR" : {
            "import_only" : 0
         },
         "CN" : {
            "import_only" : 0
         },
         "CU" : {
            "import_only" : 0
         },
         "DA" : {
            "import_only" : 0
         },
         "IN" : {
            "import_only" : 0
         },
         "IV" : {
            "import_only" : 0
         },
         "KB" : {
            "import_only" : 0
         },
         "KC" : {
            "import_only" : 0
         },
         "KG" : {
            "import_only" : 0
         },
         "KI" : {
            "import_only" : 0
         },
         "KL" : {
            "import_only" : 0
         },
         "KM" : {
            "import_only" : 0
         },
         "KR" : {
            "import_only" : 0
         },
         "KS" : {
            "import_only" : 0
         },
         "KU" : {
            "import_only" : 0
         },
         "LO" : {
            "import_only" : 0
         },
         "LP" : {
            "import_only" : 0
         },
         "MA" : {
            "import_only" : 0
         },
         "MD" : {
            "import_only" : 0
         },
         "MO" : {
            "import_only" : 0
         },
         "MR" : {
            "import_only" : 0
         },
         "MU" : {
            "import_only" : 0
         },
         "NN" : {
            "import_only" : 0
         },
         "NO" : {
            "import_only" : 0
         },
         "NV" : {
            "import_only" : 0
         },
         "OR" : {
            "import_only" : 0
         },
         "PE" : {
            "import_only" : 0
         },
         "PS" : {
            "import_only" : 0
         },
         "RA" : {
            "import_only" : 0
         },
         "RO" : {
            "import_only" : 0
         },
         "SA" : {
            "import_only" : 0
         },
         "SM" : {
            "import_only" : 0
         },
         "SO" : {
            "import_only" : 0
         },
         "SP" : {
            "import_only" : 0
         },
         "SR" : {
            "import_only" : 0
         },
         "ST" : {
            "import_only" : 0
         },
         "TA" : {
            "import_only" : 0
         },
         "TB" : {
            "import_only" : 0
         },
         "TL" : {
            "import_only" : 0
         },
         "TV" : {
            "import_only" : 0
         },
         "UD" : {
            "import_only" : 0
         },
         "UL" : {
            "import_only" : 0
         },
         "VG" : {
            "import_only" : 0
         },
         "VL" : {
            "import_only" : 0
         },
         "VO" : {
            "import_only" : 0
         },
         "VR" : {
            "import_only" : 0
         },
         "YR" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION6" : {
         "AK" : {
            "import_only" : 0
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION61" : {
         "AR" : {
            "import_only" : 0
         },
         "FJL" : {
            "import_only" : 1
         }
      },
      "PRIMARYADMINISTRATIVESUBDIVISION70" : {
         "01" : {
            "import_only" : 0
         },
         "03" : {
            "import_only" : 0
         },
         "04" : {
            "import_only" : 0
         },
         "05" : {
            "import_only" : 0
         },
         "06" : {
            "import_only" : 0
         },
         "07" : {
            "import_only" : 0
         },
         "08" : {
            "import_only" : 0
         },
         "09" : {
            "import_only" : 0
         },
         "10" : {
            "import_only" : 0
         },
         "11" : {
            "import_only" : 0
         },
         "12" : {
            "import_only" : 0
         },
         "13" : {
            "import_only" : 0
         },
         "14" : {
            "import_only" : 0
         },
         "15" : {
            "import_only" : 0
         },
         "16" : {
            "import_only" : 0
         },
         "99" : {
            "import_only" : 0
         }
      },
      "PROPAGATIONMODE" : {
         "AS" : {
            "import_only" : 0
         },
         "AUE" : {
            "import_only" : 0
         },
         "AUR" : {
            "import_only" : 0
         },
         "BS" : {
            "import_only" : 0
         },
         "ECH" : {
            "import_only" : 0
         },
         "EME" : {
            "import_only" : 0
         },
         "ENUMERATION" : {
            "import_only" : 0
         },
         "ES" : {
            "import_only" : 0
         },
         "F2" : {
            "import_only" : 0
         },
         "FAI" : {
            "import_only" : 0
         },
         "GWAVE" : {
            "import_only" : 0
         },
         "INTERNET" : {
            "import_only" : 0
         },
         "ION" : {
            "import_only" : 0
         },
         "IRL" : {
            "import_only" : 0
         },
         "LOS" : {
            "import_only" : 0
         },
         "MS" : {
            "import_only" : 0
         },
         "RPT" : {
            "import_only" : 0
         },
         "RS" : {
            "import_only" : 0
         },
         "SAT" : {
            "import_only" : 0
         },
         "TEP" : {
            "import_only" : 0
         },
         "TR" : {
            "import_only" : 0
         }
      },
      "QSLMEDIUM" : {
         "CARD" : {
            "import_only" : 0
         },
         "EQSL" : {
            "import_only" : 0
         },
         "LOTW" : {
            "import_only" : 0
         }
      },
      "QSLRCVD" : {
         "I" : {
            "import_only" : 0
         },
         "N" : {
            "import_only" : 0
         },
         "R" : {
            "import_only" : 0
         },
         "V" : {
            "import_only" : 1
         },
         "Y" : {
            "import_only" : 0
         }
      },
      "QSLSENT" : {
         "I" : {
            "import_only" : 0
         },
         "N" : {
            "import_only" : 0
         },
         "Q" : {
            "import_only" : 0
         },
         "R" : {
            "import_only" : 0
         },
         "Y" : {
            "import_only" : 0
         }
      },
      "QSLVIA" : {
         "B" : {
            "import_only" : 0
         },
         "D" : {
            "import_only" : 0
         },
         "E" : {
            "import_only" : 0
         },
         "M" : {
            "import_only" : 1
         }
      },
      "QSOCOMPLETE" : {
         "?" : {
            "import_only" : 0
         },
         "N" : {
            "import_only" : 0
         },
         "NIL" : {
            "import_only" : 0
         },
         "Y" : {
            "import_only" : 0
         }
      },
      "QSODOWNLOADSTATUS" : {
         "I" : {
            "import_only" : 0
         },
         "N" : {
            "import_only" : 0
         },
         "Y" : {
            "import_only" : 0
         }
      },
      "QSOUPLOADSTATUS" : {
         "M" : {
            "import_only" : 0
         },
         "N" : {
            "import_only" : 0
         },
         "Y" : {
            "import_only" : 0
         }
      },
      "REGION" : {
         "AI" : {
            "import_only" : 0,
            "periods" : [
               {
                  "dxcc" : "248"
               }
            ]
         },
         "BI" : {
            "import_only" : 0,
            "periods" : [
               {
                  "dxcc" : "259"
               }
            ]
         },
         "ET" : {
            "import_only" : 0,
            "periods" : [
               {
                  "dxcc" : "390"
               }
            ]
         },
         "IV" : {
            "import_only" : 0,
            "periods" : [
               {
                  "dxcc" : "206"
               }
            ]
         },
         "KO" : {
            "import_only" : 0,
            "periods" : [
               {
                  "dxcc" : "296",
                  "end" : "20120911"
               },
               {
                  "dxcc" : "0",
                  "end" : "20180120",
                  "start" : "20120912"
               },
               {
                  "dxcc" : "522",
                  "start" : "20180121"
               }
            ]
         },
         "NONE" : {
            "import_only" : 0,
            "periods" : [
               {}
            ]
         },
         "SI" : {
            "import_only" : 0,
            "periods" : [
               {
                  "dxcc" : "279"
               }
            ]
         },
         "SY" : {
            "import_only" : 0,
            "periods" : [
               {
                  "dxcc" : "248"
               }
            ]
         }
      },
      "SECONDARYADMINISTRATIVESUBDIVISION6" : {
         "AK,ALEUTIANS EAST" : {
            "import_only" : 0
         },
         "AK,ALEUTIANS ISLANDS" : {
            "import_only" : 0
         },
         "AK,ALEUTIANS WEST" : {
            "import_only" : 0
         },
         "AK,ANCHORAGE" : {
            "import_only" : 0
         },
         "AK,ANGOON" : {
            "import_only" : 0
         },
         "AK,BARROW" : {
            "import_only" : 0
         },
         "AK,BETHEL" : {
            "import_only" : 0
         },
         "AK,BRISTOL BAY" : {
            "import_only" : 0
         },
         "AK,CORDOVA-MCCARTHY" : {
            "import_only" : 0
         },
         "AK,DENALI" : {
            "import_only" : 0
         },
         "AK,DILLINGHAM" : {
            "import_only" : 0
         },
         "AK,FAIRBANKS" : {
            "import_only" : 0
         },
         "AK,FAIRBANKS NORTH STAR" : {
            "import_only" : 0
         },
         "AK,FIRST JUDICIAL DISTRICT" : {
            "import_only" : 0
         },
         "AK,FOURTH JUDICIAL DISTRICT" : {
            "import_only" : 0
         },
         "AK,HAINES" : {
            "import_only" : 0
         },
         "AK,HOONAH-ANGOON" : {
            "import_only" : 0
         },
         "AK,JUNEAU" : {
            "import_only" : 0
         },
         "AK,KENAI PENINSULA" : {
            "import_only" : 0
         },
         "AK,KENAI-COOK INLET" : {
            "import_only" : 0
         },
         "AK,KETCHIKAN" : {
            "import_only" : 0
         },
         "AK,KETCHIKAN GATEWAY" : {
            "import_only" : 0
         },
         "AK,KOBUK" : {
            "import_only" : 0
         },
         "AK,KODIAK ISLAND" : {
            "import_only" : 0
         },
         "AK,KUSILVAK" : {
            "import_only" : 0
         },
         "AK,KUSKOKWIM" : {
            "import_only" : 0
         },
         "AK,LAKE AND PENINSULA" : {
            "import_only" : 0
         },
         "AK,LYNN CANAL-ICY STRAITS" : {
            "import_only" : 0
         },
         "AK,MATANUSKA-SUSITNA" : {
            "import_only" : 0
         },
         "AK,NOME" : {
            "import_only" : 0
         },
         "AK,NORTH SLOPE" : {
            "import_only" : 0
         },
         "AK,NORTHWEST ARCTIC" : {
            "import_only" : 0
         },
         "AK,OUTER KETCHIKAN" : {
            "import_only" : 0
         },
         "AK,PALMER-WASILLA-TALKEETNA" : {
            "import_only" : 0
         },
         "AK,PETERSBURG" : {
            "import_only" : 0
         },
         "AK,PRIBILOF ISLANDS" : {
            "import_only" : 0
         },
         "AK,PRINCE OF WALES" : {
            "import_only" : 0
         },
         "AK,PRINCE OF WALES-HYDER" : {
            "import_only" : 0
         },
         "AK,PRINCE OF WALES-OUTER KETCHIKAN" : {
            "import_only" : 0
         },
         "AK,SAINT MATTHEW ISLAND" : {
            "import_only" : 0
         },
         "AK,SECOND JUDICIAL DISTRICT" : {
            "import_only" : 0
         },
         "AK,SEWARD" : {
            "import_only" : 0
         },
         "AK,SITKA" : {
            "import_only" : 0
         },
         "AK,SKAGWAY" : {
            "import_only" : 0
         },
         "AK,SKAGWAY-HOONAH-ANGOON" : {
            "import_only" : 0
         },
         "AK,SKAGWAY-YAKUTA" : {
            "import_only" : 0
         },
         "AK,SKAGWAY-YAKUTAT-ANGOON" : {
            "import_only" : 0
         },
         "AK,SOUTHEAST FAIRBANKS" : {
            "import_only" : 0
         },
         "AK,THIRD JUDICIAL DISTRICT" : {
            "import_only" : 0
         },
         "AK,UPPER YUKON" : {
            "import_only" : 0
         },
         "AK,VALDEZ-CHITINA-WHITTIER" : {
            "import_only" : 0
         },
         "AK,VALDEZ-CORDOVA" : {
            "import_only" : 0
         },
         "AK,WADE HAMPTON" : {
            "import_only" : 0
         },
         "AK,WALES-HYDER" : {
            "import_only" : 0
         },
         "AK,WRANGELL" : {
            "import_only" : 0
         },
         "AK,WRANGELL-PETERSBURG" : {
            "import_only" : 0
         },
         "AK,YAKUTAT" : {
            "import_only" : 0
         },
         "AK,YUKON-KOYUKUK" : {
            "import_only" : 0
         }
      },
      "SECONDARYADMINISTRATIVESUBDIVISIONALT170" : {
         "NZ_REGIONS:AUCKLAND/AUCKLAND" : {
            "import_only" : 0
         },
         "NZ_REGIONS:AUCKLAND/FRANKLIN" : {
            "import_only" : 0
         },
         "NZ_REGIONS:AUCKLAND/MANUKAU" : {
            "import_only" : 0
         },
         "NZ_REGIONS:AUCKLAND/NORTH SHORE" : {
            "import_only" : 0
         },
         "NZ_REGIONS:AUCKLAND/PAPAKURA" : {
            "import_only" : 0
         },
         "NZ_REGIONS:AUCKLAND/RODNEY" : {
            "import_only" : 0
         },
         "NZ_REGIONS:AUCKLAND/WAITAKERE" : {
            "import_only" : 0
         },
         "NZ_REGIONS:BAY OF PLENTY/KAWERAU" : {
            "import_only" : 0
         },
         "NZ_REGIONS:BAY OF PLENTY/OPOTIKI" : {
            "import_only" : 0
         },
         "NZ_REGIONS:BAY OF PLENTY/ROTORUA" : {
            "import_only" : 0
         },
         "NZ_REGIONS:BAY OF PLENTY/TAURANGA" : {
            "import_only" : 0
         },
         "NZ_REGIONS:BAY OF PLENTY/WESTERN BAY OF PLENTY" : {
            "import_only" : 0
         },
         "NZ_REGIONS:BAY OF PLENTY/WHAKATANE" : {
            "import_only" : 0
         },
         "NZ_REGIONS:CANTERBURY/ASHBURTON" : {
            "import_only" : 0
         },
         "NZ_REGIONS:CANTERBURY/BANKS PENINSULA" : {
            "import_only" : 0
         },
         "NZ_REGIONS:CANTERBURY/CHRISTCHURCH" : {
            "import_only" : 0
         },
         "NZ_REGIONS:CANTERBURY/HURUNUI" : {
            "import_only" : 0
         },
         "NZ_REGIONS:CANTERBURY/KAIKOURA" : {
            "import_only" : 0
         },
         "NZ_REGIONS:CANTERBURY/MACKENZIE" : {
            "import_only" : 0
         },
         "NZ_REGIONS:CANTERBURY/SELWYN" : {
            "import_only" : 0
         },
         "NZ_REGIONS:CANTERBURY/TIMARU" : {
            "import_only" : 0
         },
         "NZ_REGIONS:CANTERBURY/WAIMAKARIRI" : {
            "import_only" : 0
         },
         "NZ_REGIONS:CANTERBURY/WAIMATE" : {
            "import_only" : 0
         },
         "NZ_REGIONS:GISBORNE/GISBORNE" : {
            "import_only" : 0
         },
         "NZ_REGIONS:HAWKES BAY/CENTRAL HAWKES BAY" : {
            "import_only" : 0
         },
         "NZ_REGIONS:HAWKES BAY/HASTINGS" : {
            "import_only" : 0
         },
         "NZ_REGIONS:HAWKES BAY/NAPIER" : {
            "import_only" : 0
         },
         "NZ_REGIONS:HAWKES BAY/WAIROA" : {
            "import_only" : 0
         },
         "NZ_REGIONS:MARLBOROUGH/MARLBOROUGH" : {
            "import_only" : 0
         },
         "NZ_REGIONS:NELSON/NELSON" : {
            "import_only" : 0
         },
         "NZ_REGIONS:NORTHLAND/FAR NORTH" : {
            "import_only" : 0
         },
         "NZ_REGIONS:NORTHLAND/KAIPARA" : {
            "import_only" : 0
         },
         "NZ_REGIONS:NORTHLAND/WHANGAREI" : {
            "import_only" : 0
         },
         "NZ_REGIONS:OTAGO/CENTRAL OTAGO" : {
            "import_only" : 0
         },
         "NZ_REGIONS:OTAGO/CLUTHA" : {
            "import_only" : 0
         },
         "NZ_REGIONS:OTAGO/DUNEDIN" : {
            "import_only" : 0
         },
         "NZ_REGIONS:OTAGO/QUEENSTOWN-LAKES" : {
            "import_only" : 0
         },
         "NZ_REGIONS:OTAGO/WAITAKI" : {
            "import_only" : 0
         },
         "NZ_REGIONS:SOUTHLAND/GORE" : {
            "import_only" : 0
         },
         "NZ_REGIONS:SOUTHLAND/INVERCARGILL" : {
            "import_only" : 0
         },
         "NZ_REGIONS:SOUTHLAND/SOUTHLAND" : {
            "import_only" : 0
         },
         "NZ_REGIONS:TARANAKI/NEW PLYMOUTH" : {
            "import_only" : 0
         },
         "NZ_REGIONS:TARANAKI/SOUTH TARANAKI" : {
            "import_only" : 0
         },
         "NZ_REGIONS:TARANAKI/STRATFORD" : {
            "import_only" : 0
         },
         "NZ_REGIONS:TASMAN/TASMAN" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WAIKATO/HAMILTON" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WAIKATO/HAURAKI" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WAIKATO/MATAMATA PIAKO" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WAIKATO/OTOROHANGA" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WAIKATO/SOUTH WAIKATO" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WAIKATO/TAUPO" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WAIKATO/THAMES-COROMANDEL" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WAIKATO/WAIKATO" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WAIKATO/WAIPA" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WAIKATO/WAITOMO" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WANGANUI-MANAWATU/HOROWHENUA" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WANGANUI-MANAWATU/MANAWATU" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WANGANUI-MANAWATU/PALMERSTON NORTH" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WANGANUI-MANAWATU/RANGITIKEI" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WANGANUI-MANAWATU/RUAPEHU" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WANGANUI-MANAWATU/TARARUA" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WANGANUI-MANAWATU/WANGANUI" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WELLINGTON/CARTERTON" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WELLINGTON/KAPITI COAST" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WELLINGTON/LOWER HUTT" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WELLINGTON/MASTERTON" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WELLINGTON/PORIRUA" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WELLINGTON/SOUTH WAIRARAPA" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WELLINGTON/UPPER HUTT" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WELLINGTON/WELLINGTON" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WEST COAST/BULLER" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WEST COAST/GREY" : {
            "import_only" : 0
         },
         "NZ_REGIONS:WEST COAST/WESTLAND" : {
            "import_only" : 0
         }
      },
      "SUBMODE" : {
         "8PSK1000" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "8PSK1000F" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "8PSK1200F" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "8PSK125" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "8PSK125F" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "8PSK125FL" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "8PSK250" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "8PSK250F" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "8PSK250FL" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "8PSK500" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "8PSK500F" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "AMTORFEC" : {
            "import_only" : 0,
            "mode" : "TOR"
         },
         "ASCI" : {
            "import_only" : 0,
            "mode" : "RTTY"
         },
         "C4FM" : {
            "import_only" : 0,
            "mode" : "DIGITALVOICE"
         },
         "CHIP128" : {
            "import_only" : 0,
            "mode" : "CHIP"
         },
         "CHIP64" : {
            "import_only" : 0,
            "mode" : "CHIP"
         },
         "DMR" : {
            "import_only" : 0,
            "mode" : "DIGITALVOICE"
         },
         "DOM-M" : {
            "import_only" : 0,
            "mode" : "DOMINO"
         },
         "DOM11" : {
            "import_only" : 0,
            "mode" : "DOMINO"
         },
         "DOM16" : {
            "import_only" : 0,
            "mode" : "DOMINO"
         },
         "DOM22" : {
            "import_only" : 0,
            "mode" : "DOMINO"
         },
         "DOM4" : {
            "import_only" : 0,
            "mode" : "DOMINO"
         },
         "DOM44" : {
            "import_only" : 0,
            "mode" : "DOMINO"
         },
         "DOM5" : {
            "import_only" : 0,
            "mode" : "DOMINO"
         },
         "DOM8" : {
            "import_only" : 0,
            "mode" : "DOMINO"
         },
         "DOM88" : {
            "import_only" : 0,
            "mode" : "DOMINO"
         },
         "DOMINOEX" : {
            "import_only" : 0,
            "mode" : "DOMINO"
         },
         "DOMINOF" : {
            "import_only" : 0,
            "mode" : "DOMINO"
         },
         "DSTAR" : {
            "import_only" : 0,
            "mode" : "DIGITALVOICE"
         },
         "FMHELL" : {
            "import_only" : 0,
            "mode" : "HELL"
         },
         "FREEDATA" : {
            "import_only" : 0,
            "mode" : "DYNAMIC"
         },
         "FREEDV" : {
            "import_only" : 0,
            "mode" : "DIGITALVOICE"
         },
         "FSK31" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "FSKH105" : {
            "import_only" : 0,
            "mode" : "HELL"
         },
         "FSKH245" : {
            "import_only" : 0,
            "mode" : "HELL"
         },
         "FSKHELL" : {
            "import_only" : 0,
            "mode" : "HELL"
         },
         "FSQCALL" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "FST4" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "FST4W" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "FT2" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "FT4" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "GTOR" : {
            "import_only" : 0,
            "mode" : "TOR"
         },
         "HELL80" : {
            "import_only" : 0,
            "mode" : "HELL"
         },
         "HELLX5" : {
            "import_only" : 0,
            "mode" : "HELL"
         },
         "HELLX9" : {
            "import_only" : 0,
            "mode" : "HELL"
         },
         "HFSK" : {
            "import_only" : 0,
            "mode" : "HELL"
         },
         "ISCAT-A" : {
            "import_only" : 0,
            "mode" : "ISCAT"
         },
         "ISCAT-B" : {
            "import_only" : 0,
            "mode" : "ISCAT"
         },
         "JS8" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "JT4A" : {
            "import_only" : 0,
            "mode" : "JT4"
         },
         "JT4B" : {
            "import_only" : 0,
            "mode" : "JT4"
         },
         "JT4C" : {
            "import_only" : 0,
            "mode" : "JT4"
         },
         "JT4D" : {
            "import_only" : 0,
            "mode" : "JT4"
         },
         "JT4E" : {
            "import_only" : 0,
            "mode" : "JT4"
         },
         "JT4F" : {
            "import_only" : 0,
            "mode" : "JT4"
         },
         "JT4G" : {
            "import_only" : 0,
            "mode" : "JT4"
         },
         "JT65A" : {
            "import_only" : 0,
            "mode" : "JT65"
         },
         "JT65B" : {
            "import_only" : 0,
            "mode" : "JT65"
         },
         "JT65B2" : {
            "import_only" : 0,
            "mode" : "JT65"
         },
         "JT65C" : {
            "import_only" : 0,
            "mode" : "JT65"
         },
         "JT65C2" : {
            "import_only" : 0,
            "mode" : "JT65"
         },
         "JT9-1" : {
            "import_only" : 0,
            "mode" : "JT9"
         },
         "JT9-10" : {
            "import_only" : 0,
            "mode" : "JT9"
         },
         "JT9-2" : {
            "import_only" : 0,
            "mode" : "JT9"
         },
         "JT9-30" : {
            "import_only" : 0,
            "mode" : "JT9"
         },
         "JT9-5" : {
            "import_only" : 0,
            "mode" : "JT9"
         },
         "JT9A" : {
            "import_only" : 0,
            "mode" : "JT9"
         },
         "JT9B" : {
            "import_only" : 0,
            "mode" : "JT9"
         },
         "JT9C" : {
            "import_only" : 0,
            "mode" : "JT9"
         },
         "JT9D" : {
            "import_only" : 0,
            "mode" : "JT9"
         },
         "JT9E" : {
            "import_only" : 0,
            "mode" : "JT9"
         },
         "JT9E FAST" : {
            "import_only" : 0,
            "mode" : "JT9"
         },
         "JT9F" : {
            "import_only" : 0,
            "mode" : "JT9"
         },
         "JT9F FAST" : {
            "import_only" : 0,
            "mode" : "JT9"
         },
         "JT9G" : {
            "import_only" : 0,
            "mode" : "JT9"
         },
         "JT9G FAST" : {
            "import_only" : 0,
            "mode" : "JT9"
         },
         "JT9H" : {
            "import_only" : 0,
            "mode" : "JT9"
         },
         "JT9H FAST" : {
            "import_only" : 0,
            "mode" : "JT9"
         },
         "JTMS" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "JTTY" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "LSB" : {
            "import_only" : 0,
            "mode" : "SSB"
         },
         "M17" : {
            "import_only" : 0,
            "mode" : "DIGITALVOICE"
         },
         "MFSK11" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "MFSK128" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "MFSK128L" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "MFSK16" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "MFSK22" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "MFSK31" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "MFSK32" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "MFSK4" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "MFSK64" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "MFSK64L" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "MFSK8" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "NAVTEX" : {
            "import_only" : 0,
            "mode" : "TOR"
         },
         "OLIVIA 16/1000" : {
            "import_only" : 0,
            "mode" : "OLIVIA"
         },
         "OLIVIA 16/500" : {
            "import_only" : 0,
            "mode" : "OLIVIA"
         },
         "OLIVIA 32/1000" : {
            "import_only" : 0,
            "mode" : "OLIVIA"
         },
         "OLIVIA 4/125" : {
            "import_only" : 0,
            "mode" : "OLIVIA"
         },
         "OLIVIA 4/250" : {
            "import_only" : 0,
            "mode" : "OLIVIA"
         },
         "OLIVIA 8/250" : {
            "import_only" : 0,
            "mode" : "OLIVIA"
         },
         "OLIVIA 8/500" : {
            "import_only" : 0,
            "mode" : "OLIVIA"
         },
         "OPERA-BEACON" : {
            "import_only" : 0,
            "mode" : "OPERA"
         },
         "OPERA-QSO" : {
            "import_only" : 0,
            "mode" : "OPERA"
         },
         "PAC2" : {
            "import_only" : 0,
            "mode" : "PAC"
         },
         "PAC3" : {
            "import_only" : 0,
            "mode" : "PAC"
         },
         "PAC4" : {
            "import_only" : 0,
            "mode" : "PAC"
         },
         "PAX2" : {
            "import_only" : 0,
            "mode" : "PAX"
         },
         "PCW" : {
            "import_only" : 0,
            "mode" : "CW"
         },
         "PSK10" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK1000" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK1000RC2" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK125" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK125RC10" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK125RC12" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK125RC16" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK125RC4" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK125RC5" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK250" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK250RC2" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK250RC3" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK250RC5" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK250RC6" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK250RC7" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK31" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK500" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK500RC2" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK500RC3" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK500RC4" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK63" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK63F" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK63RC10" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK63RC20" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK63RC32" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK63RC4" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK63RC5" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSK800RC2" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSKAM10" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSKAM31" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSKAM50" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSKFEC31" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "PSKHELL" : {
            "import_only" : 0,
            "mode" : "HELL"
         },
         "Q65" : {
            "import_only" : 0,
            "mode" : "MFSK"
         },
         "QPSK125" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "QPSK250" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "QPSK31" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "QPSK500" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "QPSK63" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "QRA64A" : {
            "import_only" : 0,
            "mode" : "QRA64"
         },
         "QRA64B" : {
            "import_only" : 0,
            "mode" : "QRA64"
         },
         "QRA64C" : {
            "import_only" : 0,
            "mode" : "QRA64"
         },
         "QRA64D" : {
            "import_only" : 0,
            "mode" : "QRA64"
         },
         "QRA64E" : {
            "import_only" : 0,
            "mode" : "QRA64"
         },
         "RIBBIT_PIX" : {
            "import_only" : 0,
            "mode" : "OFDM"
         },
         "RIBBIT_SMS" : {
            "import_only" : 0,
            "mode" : "OFDM"
         },
         "ROS-EME" : {
            "import_only" : 0,
            "mode" : "ROS"
         },
         "ROS-HF" : {
            "import_only" : 0,
            "mode" : "ROS"
         },
         "ROS-MF" : {
            "import_only" : 0,
            "mode" : "ROS"
         },
         "SCAMP_FAST" : {
            "import_only" : 0,
            "mode" : "FSK"
         },
         "SCAMP_OO" : {
            "import_only" : 0,
            "mode" : "MTONE"
         },
         "SCAMP_OO_SLW" : {
            "import_only" : 0,
            "mode" : "MTONE"
         },
         "SCAMP_SLOW" : {
            "import_only" : 0,
            "mode" : "FSK"
         },
         "SCAMP_VSLOW" : {
            "import_only" : 0,
            "mode" : "FSK"
         },
         "SIM31" : {
            "import_only" : 0,
            "mode" : "PSK"
         },
         "SITORB" : {
            "import_only" : 0,
            "mode" : "TOR"
         },
         "SLOWHELL" : {
            "import_only" : 0,
            "mode" : "HELL"
         },
         "THOR-M" : {
            "import_only" : 0,
            "mode" : "THOR"
         },
         "THOR100" : {
            "import_only" : 0,
            "mode" : "THOR"
         },
         "THOR11" : {
            "import_only" : 0,
            "mode" : "THOR"
         },
         "THOR16" : {
            "import_only" : 0,
            "mode" : "THOR"
         },
         "THOR22" : {
            "import_only" : 0,
            "mode" : "THOR"
         },
         "THOR25X4" : {
            "import_only" : 0,
            "mode" : "THOR"
         },
         "THOR4" : {
            "import_only" : 0,
            "mode" : "THOR"
         },
         "THOR5" : {
            "import_only" : 0,
            "mode" : "THOR"
         },
         "THOR50X1" : {
            "import_only" : 0,
            "mode" : "THOR"
         },
         "THOR50X2" : {
            "import_only" : 0,
            "mode" : "THOR"
         },
         "THOR8" : {
            "import_only" : 0,
            "mode" : "THOR"
         },
         "THRBX" : {
            "import_only" : 0,
            "mode" : "THRB"
         },
         "THRBX1" : {
            "import_only" : 0,
            "mode" : "THRB"
         },
         "THRBX2" : {
            "import_only" : 0,
            "mode" : "THRB"
         },
         "THRBX4" : {
            "import_only" : 0,
            "mode" : "THRB"
         },
         "THROB1" : {
            "import_only" : 0,
            "mode" : "THRB"
         },
         "THROB2" : {
            "import_only" : 0,
            "mode" : "THRB"
         },
         "THROB4" : {
            "import_only" : 0,
            "mode" : "THRB"
         },
         "USB" : {
            "import_only" : 0,
            "mode" : "SSB"
         }
      }
   },
   "fields" : {
      "ADDRESS" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "MultilineString"
      },
      "ADDRESS_INTL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlMultilineString"
      },
      "ADIF_VER" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "header",
         "type" : "String"
      },
      "AGE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Number"
      },
      "ALTITUDE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Number"
      },
      "ANT_AZ" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Number"
      },
      "ANT_EL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Number"
      },
      "ANT_PATH" : {
         "enum" : "ANTPATH",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "ARRL_SECT" : {
         "enum" : "ARRLSECTION",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "AWARD_GRANTED" : {
         "enum" : "SPONSOREDAWARD",
         "import_only" : 0,
         "scope" : "record",
         "type" : "SponsoredAwardList"
      },
      "AWARD_SUBMITTED" : {
         "enum" : "SPONSOREDAWARD",
         "import_only" : 0,
         "scope" : "record",
         "type" : "SponsoredAwardList"
      },
      "A_INDEX" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Number"
      },
      "BAND" : {
         "enum" : "BAND",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "BAND_RX" : {
         "enum" : "BAND",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "CALL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "CHECK" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "CLASS" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "CLUBLOG_QSO_UPLOAD_DATE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Date"
      },
      "CLUBLOG_QSO_UPLOAD_STATUS" : {
         "enum" : "QSOUPLOADSTATUS",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "CNTY" : {
         "enum" : "SECONDARYADMINISTRATIVESUBDIVISION",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "CNTY_ALT" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "SecondaryAdministrativeSubdivisionListAlt"
      },
      "COMMENT" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "COMMENT_INTL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlString"
      },
      "CONT" : {
         "enum" : "CONTINENT",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "CONTACTED_OP" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "CONTEST_ID" : {
         "enum" : "CONTESTID",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "COUNTRY" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "COUNTRY_INTL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlString"
      },
      "CQZ" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "PositiveInteger"
      },
      "CREATED_TIMESTAMP" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "header",
         "type" : "String"
      },
      "CREDIT_GRANTED" : {
         "enum" : "CREDIT",
         "import_only" : 0,
         "scope" : "record",
         "type" : "CreditList"
      },
      "CREDIT_SUBMITTED" : {
         "enum" : "CREDIT",
         "import_only" : 0,
         "scope" : "record",
         "type" : "CreditList"
      },
      "DARC_DOK" : {
         "enum" : "XLDARC",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "DCL_QSLRDATE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Date"
      },
      "DCL_QSLSDATE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Date"
      },
      "DCL_QSL_RCVD" : {
         "enum" : "QSLRCVD",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "DCL_QSL_SENT" : {
         "enum" : "QSLSENT",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "DISTANCE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Number"
      },
      "DXCC" : {
         "enum" : "DXCCENTITYCODE",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "EMAIL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "EQSL_AG" : {
         "enum" : "EQSLAG",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "EQSL_QSLRDATE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Date"
      },
      "EQSL_QSLSDATE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Date"
      },
      "EQSL_QSL_RCVD" : {
         "enum" : "QSLRCVD",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "EQSL_QSL_SENT" : {
         "enum" : "QSLSENT",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "EQ_CALL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "FISTS" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "PositiveInteger"
      },
      "FISTS_CC" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "PositiveInteger"
      },
      "FORCE_INIT" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Boolean"
      },
      "FREQ" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Number"
      },
      "FREQ_RX" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Number"
      },
      "GRIDSQUARE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "GridSquare"
      },
      "GRIDSQUARE_EXT" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "GridSquareExt"
      },
      "GUEST_OP" : {
         "enum" : "",
         "import_only" : 1,
         "scope" : "record",
         "type" : "String"
      },
      "HAMLOGEU_QSO_UPLOAD_DATE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Date"
      },
      "HAMLOGEU_QSO_UPLOAD_STATUS" : {
         "enum" : "QSOUPLOADSTATUS",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "HAMQTH_QSO_UPLOAD_DATE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Date"
      },
      "HAMQTH_QSO_UPLOAD_STATUS" : {
         "enum" : "QSOUPLOADSTATUS",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "HRDLOG_QSO_UPLOAD_DATE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Date"
      },
      "HRDLOG_QSO_UPLOAD_STATUS" : {
         "enum" : "QSOUPLOADSTATUS",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "IOTA" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IOTARefNo"
      },
      "IOTA_ISLAND_ID" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "PositiveInteger"
      },
      "ITUZ" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "PositiveInteger"
      },
      "K_INDEX" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Integer"
      },
      "LAT" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Location"
      },
      "LON" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Location"
      },
      "LOTW_QSLRDATE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Date"
      },
      "LOTW_QSLSDATE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Date"
      },
      "LOTW_QSL_RCVD" : {
         "enum" : "QSLRCVD",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "LOTW_QSL_SENT" : {
         "enum" : "QSLSENT",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "MAX_BURSTS" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Number"
      },
      "MODE" : {
         "enum" : "MODE",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "MORSE_KEY_INFO" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "MORSE_KEY_TYPE" : {
         "enum" : "MORSEKEYTYPE",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "MS_SHOWER" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "MY_ALTITUDE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Number"
      },
      "MY_ANTENNA" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "MY_ANTENNA_INTL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlString"
      },
      "MY_ARRL_SECT" : {
         "enum" : "ARRLSECTION",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "MY_CITY" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "MY_CITY_INTL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlString"
      },
      "MY_CNTY" : {
         "enum" : "SECONDARYADMINISTRATIVESUBDIVISION",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "MY_CNTY_ALT" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "SecondaryAdministrativeSubdivisionListAlt"
      },
      "MY_COUNTRY" : {
         "enum" : "DXCCENTITYCODE",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "MY_COUNTRY_INTL" : {
         "enum" : "DXCCENTITYCODE",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlString"
      },
      "MY_CQ_ZONE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "PositiveInteger"
      },
      "MY_DARC_DOK" : {
         "enum" : "XLDARC",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "MY_DXCC" : {
         "enum" : "DXCCENTITYCODE",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "MY_FISTS" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "PositiveInteger"
      },
      "MY_GRIDSQUARE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "GridSquare"
      },
      "MY_GRIDSQUARE_EXT" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "GridSquareExt"
      },
      "MY_IOTA" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IOTARefNo"
      },
      "MY_IOTA_ISLAND_ID" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "PositiveInteger"
      },
      "MY_ITU_ZONE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "PositiveInteger"
      },
      "MY_LAT" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Location"
      },
      "MY_LON" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Location"
      },
      "MY_MORSE_KEY_INFO" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "MY_MORSE_KEY_TYPE" : {
         "enum" : "MORSEKEYTYPE",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "MY_NAME" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "MY_NAME_INTL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlString"
      },
      "MY_POSTAL_CODE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "MY_POSTAL_CODE_INTL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlString"
      },
      "MY_POTA_REF" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "POTARefList"
      },
      "MY_RIG" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "MY_RIG_INTL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlString"
      },
      "MY_SIG" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "MY_SIG_INFO" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "MY_SIG_INFO_INTL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlString"
      },
      "MY_SIG_INTL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlString"
      },
      "MY_SOTA_REF" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "SOTARef"
      },
      "MY_STATE" : {
         "enum" : "PRIMARYADMINISTRATIVESUBDIVISION",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "MY_STREET" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "MY_STREET_INTL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlString"
      },
      "MY_USACA_COUNTIES" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "SecondarySubdivisionList"
      },
      "MY_VUCC_GRIDS" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "GridSquareList"
      },
      "MY_WWFF_REF" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "WWFFRef"
      },
      "NAME" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "NAME_INTL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlString"
      },
      "NOTES" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "MultilineString"
      },
      "NOTES_INTL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlMultilineString"
      },
      "NR_BURSTS" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Integer"
      },
      "NR_PINGS" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Integer"
      },
      "OPERATOR" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "OWNER_CALLSIGN" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "PFX" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "POTA_REF" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "POTARefList"
      },
      "PRECEDENCE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "PROGRAMID" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "header",
         "type" : "String"
      },
      "PROGRAMVERSION" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "header",
         "type" : "String"
      },
      "PROP_MODE" : {
         "enum" : "PROPAGATIONMODE",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "PUBLIC_KEY" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "QRZCOM_QSO_DOWNLOAD_DATE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Date"
      },
      "QRZCOM_QSO_DOWNLOAD_STATUS" : {
         "enum" : "QSODOWNLOADSTATUS",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "QRZCOM_QSO_UPLOAD_DATE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Date"
      },
      "QRZCOM_QSO_UPLOAD_STATUS" : {
         "enum" : "QSOUPLOADSTATUS",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "QSLMSG" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "MultilineString"
      },
      "QSLMSG_INTL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlMultilineString"
      },
      "QSLMSG_RCVD" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "MultilineString"
      },
      "QSLRDATE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Date"
      },
      "QSLSDATE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Date"
      },
      "QSL_RCVD" : {
         "enum" : "QSLRCVD",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "QSL_RCVD_VIA" : {
         "enum" : "QSLVIA",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "QSL_SENT" : {
         "enum" : "QSLSENT",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "QSL_SENT_VIA" : {
         "enum" : "QSLVIA",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "QSL_VIA" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "QSO_COMPLETE" : {
         "enum" : "QSOCOMPLETE",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "QSO_DATE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Date"
      },
      "QSO_DATE_OFF" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Date"
      },
      "QSO_RANDOM" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Boolean"
      },
      "QTH" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "QTH_INTL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlString"
      },
      "REGION" : {
         "enum" : "REGION",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "RIG" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "MultilineString"
      },
      "RIG_INTL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlMultilineString"
      },
      "RST_RCVD" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "RST_SENT" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "RX_PWR" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Number"
      },
      "SAT_MODE" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "SAT_NAME" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "SFI" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Integer"
      },
      "SIG" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "SIG_INFO" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "SIG_INFO_INTL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlString"
      },
      "SIG_INTL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "IntlString"
      },
      "SILENT_KEY" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Boolean"
      },
      "SKCC" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "SOTA_REF" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "SOTARef"
      },
      "SRX" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Integer"
      },
      "SRX_STRING" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "STATE" : {
         "enum" : "PRIMARYADMINISTRATIVESUBDIVISION",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Enumeration"
      },
      "STATION_CALLSIGN" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "STX" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Integer"
      },
      "STX_STRING" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "SUBMODE" : {
         "enum" : "SUBMODE",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "SWL" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Boolean"
      },
      "TEN_TEN" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "PositiveInteger"
      },
      "TIME_OFF" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Time"
      },
      "TIME_ON" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Time"
      },
      "TX_PWR" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "Number"
      },
      "UKSMG" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "PositiveInteger"
      },
      "USACA_COUNTIES" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "SecondarySubdivisionList"
      },
      "VE_PROV" : {
         "enum" : "",
         "import_only" : 1,
         "scope" : "record",
         "type" : "String"
      },
      "VUCC_GRIDS" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "GridSquareList"
      },
      "WEB" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "String"
      },
      "WWFF_REF" : {
         "enum" : "",
         "import_only" : 0,
         "scope" : "record",
         "type" : "WWFFRef"
      }
   }
}
