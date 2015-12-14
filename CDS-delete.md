% Title = "Removing DS records from parent via CDS/CDNSKEY" 
% abbrev = "DS-remove"
% category = "info"
% docName = "draft-ogud-dnsop-ds-remove-00"
% ipr= "trust200902"
% area = "Operations"
% workgroup = ""
% keyword = ["dnssec", "trust maintainance"]
%
% date = 2015-08-25T00:00:00Z
%
% [[author]]
% initials="O."
% surname="Gudmundsson"
% fullname="Olafur Gudmundsson"
% #role="editor"
% organization = "CloudFlare"
%   [author.address]
%   email = "olafur+ietf@cloudflare.com"
%   [author.address.postal]
%   street = ""

.# Abstract

RFC7344 specifies how trust can be maintained in-band between parent and child. There are two features missing in that specification: initial trust setup and removal of trust anchor. This document addresses the second omission. 

There are many reasons why a domain may want to go unsigned. Some of them are related to DNS operator changes, others are related to DNSSEC signing system changes. The inability to turn off DNSSEC via in-band signalling is seen as a liability in some circles. This document addresses the issue in a sane way. 

{mainmatter}

# Introduction

CDS/CDNSKEY [@!RFC7344] records are used to signal changes in trust anchors, this is a great way to maintain delegations when the DNS operator has no other way to notify parent that changes are needed. The original versions of the draft that became RFC7344 contained a "delete" signal, the DNSOP working group at the time did not want that feature, thus it was removed. 

This document re-introduces the delete option for both CDS and CDNSKEY. 
The reason is simply that it is necessary to be able to turn off DNSSEC. 
The main reason has to do with when a domain is moved from one DNS operator to another one. Common scenarios include: 
{style="format (%I)"}
1. moving from a DNSSEC operator to a non-DNSSEC capable one
2. moving to one that cannot/does-not-want to do a proper DNSSEC rollover 
3. user does not want DNSSEC 

Whatever the reason, the lack of a "remove my DS" option is turning into the latest excuse as why DNSSEC cannot be deployed.

## Terminology
The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", 
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [@RFC2119].


# DNSSEC Delete Algorithm 
The DNSKEY algorithm registry contains two reserved values: 0 and 255[@!RFC4034].
The CERT record [@RFC4398] defines the value 0 to mean the algorithm in the CERT record is not defined in DNSSEC.  
For this reason, using the value 0 in CDS/CDNSKEY delete operations is potentially problematic, but we propose that here anyway as the risk is minimal. The alternative is to reserve one DNSSEC algorithm number for this purpose. 

Right now, no DNSSEC validator understands algorithm 0 as a valid signature algorithm, thus if the validator sees a DNSKEY or DS record with this value, it will treat it as unknown. Accordingly, the zone is treated as unsigned unless there are other algorithms present. 

In the context of CDS and CDNSKEY records, DNSSEC algorithm 0 is defined and means delete the DS set. The contents of the records MUST contain only the fixed fields as show below.
{style="format (%I)"} 
1.    CDS 0 0 0
2.    CDNSKEY 0 3 0

The there is no keying information in the records, just the command to delete all DS records. This record is signed in the same way as CDS/CDNSKEY is signed. 

Once the parent has verified the CDS/CDNSKEY record and it has passed other acceptance tests, the DS record MUST be removed. At this point the child can start the process of turning DNSSEC off. 


# Security considerations 
This document is about avoiding validation failures when a domain moves from one DNS operator to another one. 
In most cases it is preferable that operators collaborate on the rollover by doing a KSK+ZSK rollover as part of the handoff, but that is not always possible. This document addresses the case where unsigned state is needed. 


This document does not introduce any new problems, but like Negative Trust Anchor[@?I-D.ietf-dnsop-negative-trust-anchors], it addresses operational reality. 


# IANA considerations 
This document updates the following IANA registries: "DNS Security Algorithm Numbers"

Algorithm 0 adds a reference to this document. 

{backmatter}

# Acknowledgements 
This document is generated using the mmark tool that Miek Gieben has developed.

The kick in the rear to finally write this draft came from Jacques LaTour and Paul Wouters. 
