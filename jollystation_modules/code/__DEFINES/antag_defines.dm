/// Initial / base TC for advanced traitors.
#define TRAITOR_PLUS_INITIAL_TC 8
/// Max amount of TC advanced traitors can get.
#define TRAITOR_PLUS_MAX_TC 40

/// Initial / base processing points for malf AI advanced traitors.
#define TRAITOR_PLUS_INITIAL_MALF_POINTS 20
/// Max amount of processing points for malf AI advanced traitors.
#define TRAITOR_PLUS_MAX_MALF_POINTS 60

/// Max amount of goals an advanced traitor can add.
#define TRAITOR_PLUS_MAX_GOALS 5
/// Max amount of similar objectives an advanced traitor can add.
#define TRAITOR_PLUS_MAX_SIMILAR_OBJECTIVES 5

/// Max char length of goals.
#define TRAITOR_PLUS_MAX_GOAL_LENGTH 250
/// Max chat length of notes.
#define TRAITOR_PLUS_MAX_NOTE_LENGTH 175

/// List of strings - Intensity levels for advanced traitors.
/// The first char is converted to a num when selected.
#define TRAITOR_PLUS_INTENSITIES list( \
	"5 = Mass killings, destroying entire departments", \
	"4 = Mass sabotage (engine delamination)", \
	"3 = Assassination / Grand Theft", \
	"2 = Kidnapping / Theft", \
	"1 = Minor theft or basic antagonizing" )
