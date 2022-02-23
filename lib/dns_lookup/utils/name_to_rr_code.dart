// Project imports:
import 'package:network_arch/dns_lookup/utils/rr_code_name.dart';

int nameToRrCode(rrCodeName name) {
  switch (name) {
    case rrCodeName.A:
      return 1;
    case rrCodeName.NULL:
      return 10;
    case rrCodeName.AAAA:
      return 28;
    case rrCodeName.AFSDB:
      return 18;
    case rrCodeName.APL:
      return 42;
    case rrCodeName.CAA:
      return 257;
    case rrCodeName.CDNSKEY:
      return 60;
    case rrCodeName.CDS:
      return 59;
    case rrCodeName.CERT:
      return 37;
    case rrCodeName.CNAME:
      return 5;
    case rrCodeName.DHCID:
      return 49;
    case rrCodeName.DLV:
      return 32769;
    case rrCodeName.DNAME:
      return 39;
    case rrCodeName.DNSKEY:
      return 48;
    case rrCodeName.DS:
      return 43;
    case rrCodeName.HIP:
      return 55;
    case rrCodeName.HINFO:
      return 13;
    case rrCodeName.IPSECKEY:
      return 45;
    case rrCodeName.KEY:
      return 25;
    case rrCodeName.KX:
      return 36;
    case rrCodeName.LOC:
      return 29;
    case rrCodeName.MX:
      return 15;
    case rrCodeName.NAPTR:
      return 35;
    case rrCodeName.NS:
      return 2;
    case rrCodeName.NSEC:
      return 47;
    case rrCodeName.NSEC3:
      return 50;
    case rrCodeName.NSEC3PARAM:
      return 51;
    case rrCodeName.PTR:
      return 12;
    case rrCodeName.RRSIG:
      return 46;
    case rrCodeName.RP:
      return 17;
    case rrCodeName.SIG:
      return 24;
    case rrCodeName.SOA:
      return 6;
    case rrCodeName.SPF:
      return 99;
    case rrCodeName.SRV:
      return 33;
    case rrCodeName.SSHFP:
      return 44;
    case rrCodeName.TA:
      return 32768;
    case rrCodeName.TKEY:
      return 249;
    case rrCodeName.TLSA:
      return 52;
    case rrCodeName.TSIG:
      return 250;
    case rrCodeName.TXT:
      return 16;
    case rrCodeName.AXFR:
      return 252;
    case rrCodeName.IXFR:
      return 251;
    case rrCodeName.OPT:
      return 41;
    case rrCodeName.ANY:
      return 255;
    case rrCodeName.UNKNOWN:
      return -1;
  }
}