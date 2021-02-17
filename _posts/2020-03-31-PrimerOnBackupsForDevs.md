---
layout: post
title:  "A Primer on Backups for Developers Moving to Ops"
date:   2020-03-31 11:17:13 +1100
tags: [Development, DevOps, Backups]
ogimage: "/assets/posts/2020-03-31-PrimerOnBackupsForDevs.md/ogimage.png"
comments: true
permalink: /2020/03/31/PrimerOnBackupsForDevs.html
---

It’s [World Backup Day](http://www.worldbackupday.com/en/)! Let’s dive into discussing backup strategies, whether cloud or on-prem.

While cloud providers have made life real easy when provisioning services, the trend towards cloud has also changed what modern IT roles look like. There is often a lot of crossover between developers, network engineers and server administrators. It’s not uncommon to see developers provisioning new services, or stepping into SRE/DevOps roles. Unfortunately, sometimes this comes with the risk of gaps in skill sets. Providers have a lot of value-adds or cheap features like snapshots which are deceptive to people not familiar with IT/infrastructure planning that are now performing more of these duties. Modern cloud services don’t replace or discard traditional IT/Infrastructure processes like tiered backup strategies.

What do your backups in the cloud look like? Sure, you have automated deployments but how long will it take to restore a service? How much data will you lose? Can you quickly roll back the changes from a rogue script? Do your backups cover a catastrophic failure of your cloud provider?

<!--more-->

## Not All Backups Are Equal

When cloud provider [Gandi suffered a catastrophic storage failure in January](https://news.ycombinator.com/item?id=22001822) there was a flurry of frustration on hacker news and twitter. [There were a lot of comments from customers that were (understandably) absolutely livid their data had been lost](https://twitter.com/andreaganduglia/status/1215208387169980416?s=20). There were a lot of accusations that they had paid for snapshots which were called backups by Gandi. The vocal customers were now convinced these weren’t actually backups and this was false advertising. While I can’t condone Gandi's response or handling of the situation, I don’t believe this to be false advertising. Rather the customers were using the backup service incorrectly by relying on it as their sole backup. Gandi has since [revised their documentation to be clearer that these don’t replace complete copy backups](https://docs.gandi.net/en/cloud/volume_management/volume_snapshots.html#volume-snapshots).

Of course, when things go south frustrations are high and you want solutions. You don’t want a response that boils down to basically "I told you so". This is why it’s important to be proactive in planning backups. You need to understand the differences between backup types, research the backup services you use, and have a tiered strategy in place. By being proactive, if and when everything fails hopefully you’ll be a little less powerless.

### Snapshots vs Complete Copies

Snapshots are generally accomplished with a filesystem or file that supports a [Copy-On-Write (CoW)](https://en.wikipedia.org/wiki/Copy-on-write), [Redirect-On-Write (RoW)](https://storageswiss.com/2016/04/01/snapshot-101-copy-on-write-vs-redirect-on-write/) or transaction based storage strategy. I won’t go into the differences between these strategies since they are all quite different and there are plenty of devils in the details. The thing they all have in common though is that they store data in hierarchical or differencing data structures. This means when a snapshot is made the existing data becomes the baseline, and any new writes are stored as changes or deltas. Every snapshot is linked to the base filesystem state and possibly several snapshots. A small list of examples of these types of system are:

* Volume Shadow Services/Volume Shadow Copy/"Previous versions” in Windows
* BtrFS
* ZFS
* LVM on *nix systems
* VM snapshots in most hypervisors.

For developers I like to draw a parallel between this and version control like git, subversion or perforce. If your repository corrupts, all work is lost.

The advantage of these strategies is that snapshots are incredibly lightweight and can generally be created nearly instantly. Recovery/Restoration is generally just as quick. This makes it a great protection from accidental changes, users accidentally deleting files, or rollback of failed upgrades/changes.

The major downside from a backup perspective is if the underlying storage fails or has a fault, conceivably all the data and all the snapshots could become corrupt in one fell swoop. It does not provide protection from a fire in your DC/office, catastrophic storage failure, or theft. These types of backups also aren’t effective for some types of planned changes either. I’ve heard a few too many stories of people taking a snapshot of a VM as their backup before resizing a volume and losing the lot.

There [are other tradeoffs with CoW, RoW, similar filesystems and with VM snapshots](https://storageswiss.com/2016/04/01/snapshot-101-copy-on-write-vs-redirect-on-write/), including fragmentation and performance tradeoffs. These are not relevant to the discussion of backups, however you should read up on your underlying technology to know of these issues before using snapshots.

Complete copies on the other hand, are exactly that. They can be made on the same device or to other devices in other parts of the world. The downsides are that they generally take a significant amount of time, and take up just as much space if you aren’t using compression. These downsides can be mitigated by doing delta/incremental/change backups. However, as with snapshots, any corruption in a set of incremental backups could lead to a complete loss of the backups in that particular collection.

#### When to use Snapshots vs complete copies

Snapshots are great backups to take regularly. They can be used to rollback accidental changes, or reverse the results of a bad script which has mass deleted files for instance. These provide your first line of defense. It’s the quickest backup to take, and the quickest to restore. Because they are so lightweight you can take them frequently, often several times per day to several times per hour, depending on several factors. Filesystem snapshots tend to incur less penalties than snapshots of VMs which often have a more complex structure allowing for branching snapshot structures. Depending on the underlying strategy of the snapshot there can be performance penalties from these. It’s important to read up on your particular system and judge based on your use case.

Complete copies are generally the backbone of your disaster recovery (DR) backup strategy. They incur no ongoing performance penalties, allow offsite backups, and this is how your longer term weekly, monthly and yearly backups probably look. Using incremental backups can greatly speed up the time to backup.  However, think carefully about how you separate your incremental backup sets and avoid incremental backups for your monthly and yearly backups. You don’t want to be sequentially restoring 365 days of backups because you didn’t take a fresh full backup more frequently.

## No cloud provider is failsafe

A quick search and clicking the first link for "[AWS data loss](https://www.virtualizationhowto.com/2019/09/amazon-aws-data-loss-shows-cloud-backups-are-crucial/)", “[google data loss](https://www.geek.com/google/google-suffers-data-loss-as-data-center-gets-hit-by-lightning-4-times-1631739/)” and “[azure data loss](https://nakedsecurity.sophos.com/2019/02/01/dns-outage-turns-tables-on-azure-database-users/)” shows these aren’t uncommon events, and they arise from many factors. This clearly isn’t just a small provider problem.

Nothing can absolutely guarantee a bad change isn’t pushed, or prevent a physical disaster happening. Contracts, SLAs and data loss guarantees don’t save your data, they only give you some legal recourse for discounts, reimbursement or compensation in the event of a catastrophic event. Good luck explaining that one to your directors when months of data is lost.

## Comprehensive backup plan

A comprehensive backup plan, whether on-prem or on-cloud, should account for:

* Accidental actions by users
* Rogue scripts
* Ransomware
* Hardware failure
* Natural disasters
* Catastrophic provider failure

The first 2 are reasonably well covered by snapshots. Take them often, and the rollback will go unnoticed.

Ransomware increasingly has functionality to encrypt or delete online backups. [Mikko Hypponen](https://www.techrepublic.com/article/mac-os-x-ransomware-how-keranger-is-a-shadow-of-malware-to-come/) has a special term for this:

> "The prime way for recovering from a ransomware attack is recovering your backups. If it encrypts backups, you can't retrieve the data. We have a technical term for ransomware trojans that go after backups. This is known as a dick move,"

This means you need a way of having offline, or offline-like backups. Snapshots are absolutely not good enough here. They need to be copied to another provider, another disconnected storage medium, or some other strategy that provides good separation. If you have a backup agent on a system that is infected which stores an authorization key, you can assume that the next backup system will be compromised.

Hardware failure and lightning strikes will mostly be covered by offline backups as well.

Natural disasters and catastrophic provider failure require off site backup. Whether that is to another AZ/region, to one of your office locations, or to another cloud provider entirely, is up to you. Plans for any of these should provide reasonable protection from a catastrophic event.

### There are always compromises

Every company & team ever has always wanted more money for backups and DR. The simple fact is rarely will there be enough budget for a "perfect" backup and DR strategy.

In the perfect world everything will have a complete second environment, in addition to a perfect tiered backup solution. The secondary environment replicates the primary environment and has a perfectly configured auto failover process.

Unfortunately there are always compromises here. Sometimes you won’t have any failover, and the DR strategy only has weekly backups offsite. This could mean downtime from a few days to a few weeks. Sometimes there will be things that need to be restored next business day, and some things can be lost or can be down for longer.

These are all perfectly acceptable compromises as long as they are known and planned in advance. The best you can do is lay out the costs and let the business know the compromises that come along with the lower cost options. The business can decide the acceptable risk vs the cost and plans can then be put in place. 

## Testing Backups

Backups are worthless if they can’t be used to restore your services. Testing them is a critical step, and it is skipped surprisingly often.

Testing involves 2 aspects. First, testing what you backup. It’s all too easy to backup a datastore and forget a crucial config or index file, without which the data is almost worthless. Second, testing the service or media you are backing up to for reliability and [bit rot](https://en.wikipedia.org/wiki/Data_degradation). Periodically checking these is advisable. Usually a checksum/hash is enough for regular testing of previously stored data.

Schedule time to restore each of the services into a low cost dev environment over time.

## Testing DR

An extreme activity I’ve heard of to test your preparedness for a disaster event is to gather your team (or a part of your team) into a room with no notice of what is about to happen. Give them a blank laptop and say "The data center is to be considered destroyed, start restoring what you can".

This is an interesting one to consider even as a thought exercise. It raises so many questions. Even the very first step, how do you get access to your team's admin credentials repository? Do you remember the URL? The master password? Or is that all stored on a filesystem that is in an encrypted backup in the cloud somewhere? Or is it on a tape in the now inaccessible data center?

While enacting a DR plan for real sounds like hell on earth, the problem solver in me thinks this could be a fun activity in a low stakes practice run. It’ll certainly highlight the weak points in your plans.

## Summary

Backups are not a trivial exercise. Even with the best planning, an incorrect configuration can mean "bad"(encrypted, corrupted, or partial) data is backed up. Remember that not all backups are equal, so don’t fall for marketing around simple snapshot backups and ignore the backup basics. Nothing can be considered foolproof. There are a lot of things outside your control. It will all come down to a cost/benefit trade off. Consider how much data loss and downtime is acceptable weighed against what you are willing to spend.

You need to consider what it would cost your business to lose a service, or worse case, all IT assets. How long is an acceptable down time? 1 hour to restore? A day? A week? How much data could you afford to lose? Could you lose a day of work and recover without much of a hitch? Could you lose a week? Or would even a single lost transaction be disastrous? All these considerations need to feed into your backup and DR plans.

