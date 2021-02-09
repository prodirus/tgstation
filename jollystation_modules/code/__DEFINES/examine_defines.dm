//Skyrat SS13 Code Adapted for Jollystation, originally written by Gandalf2k15.
/*
These are the defines for controlling what conditions are required to display
an items special description.
See the examinemore module for information.
*/

/// Displays the special_desc regardless if it's set.
#define EXAMINE_CHECK_NONE "none"
/// For displaying descriptors for those with the SYNDICATE faction assigned.
#define EXAMINE_CHECK_SYNDICATE "syndicate"
/// Same as above, but displays "The [src] looks like a toy, not the real thing." to non-syndicates.
#define EXAMINE_CHECK_SYNDICATE_TOY "syndicate_toy"
/// For displaying descriptors for those with a mindshield implant.
#define EXAMINE_CHECK_MINDSHIELD "mindshield"
/// For displaying description information based on a specific ROLE, e.g. traitor. Pass a list of string "Role"
#define EXAMINE_CHECK_ROLE "role"
/// For displaying descriptors for specific jobs, e.g scientist. Pass a list of string "Job"
#define EXAMINE_CHECK_JOB "job"
/// For displaying descriptors for mob factions, e.g. a zombie, or... turrets. Or syndicate. Pass a list of type "faction"
// NOTE: factions aren't often set very consistently, so this might not work as anticipated. You should try to use other checks before faction if possible.
#define EXAMINE_CHECK_FACTION "faction"
/// For displaying descriptors for people with certain skill-chips. Pass a list of type "/obj/item/skillchip"
#define EXAMINE_CHECK_SKILLCHIP "skillchip"
/// For displayind descriptors for people with certain traits. Pass a list of string "trait"
#define EXAMINE_CHECK_TRAIT "trait"
/// For displayind descriptors for people of certain species. Pass it a list of types "/datum/species"
#define EXAMINE_CHECK_SPECIES "species"
