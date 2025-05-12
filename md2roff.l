%{
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define FLAG_CONVERT_TO_PDF 0x1
#define FLAG_BREAK_FRONT_PAGE 0x2
#define FLAG_NO_DATE_DISPLAY 0x4

void do_pre(char *, int);
void do_surround(char *, int);
FILE *open_file(const char *, const char *);
void parse_args(int, char **);
void print_head(void);
char *strip_surround(char *, int);
char *strip_whitespace(char *);

void usage(void);

enum {
	PRE_TL,
	PRE_SH1,
	PRE_SH2,
	PRE_SH3,
	PRE_SH4,
	PRE_SH5,
	PRE_IP,
	SUR_BI,
	SUR_B,
	SUR_I,
	SUR_UL,
	SUR_M
};

typedef struct md2roff_args_s {
	FILE *input;
	FILE *output;
	char *output_path;
	char *title;
	char *author;
	uint8_t flags;
} md2roff_args_t;
md2roff_args_t args;
%}

%option noyywrap
%option yylineno
STRING [a-zA-Z0-9!@#$%^&(),.?/\\\-<>|\{\}\[\]\"\' \t]

%%
"# "{STRING}+"\n" do_pre(yytext, PRE_SH1);
"## "{STRING}+"\n" do_pre(yytext, PRE_SH2);
"### "{STRING}+"\n" do_pre(yytext, PRE_SH3);
"#### "{STRING}+"\n" do_pre(yytext, PRE_SH4);
"##### "{STRING}+"\n" do_pre(yytext, PRE_SH5);
"* " do_pre(yytext, PRE_IP);
"***"{STRING}+"***" do_surround(yytext, SUR_BI);
"**"{STRING}+"**" do_surround(yytext, SUR_B);
"*"{STRING}+"*" do_surround(yytext, SUR_I);
"__"{STRING}+"__" do_surround(yytext, SUR_UL);
"`"{STRING}+"`" do_surround(yytext, SUR_M);
"\n\n" printf("\n.PP\n");
%%

/*
 * Process stuff at the start of the line in Markdown (#, ##, *, etc).
 */
void do_pre(char *text, int type)
{
	switch (type) {
		case PRE_SH1: fprintf(args.output, ".NH 1\n%s\n.PP", strip_whitespace(&text[2])); break;
		case PRE_SH2: fprintf(args.output, ".NH 2\n%s\n.PP", strip_whitespace(&text[3])); break;
		case PRE_SH3: fprintf(args.output, ".NH 3\n%s\n.PP", strip_whitespace(&text[4])); break;
		case PRE_SH4: fprintf(args.output, ".NH 4\n%s\n.PP", strip_whitespace(&text[5])); break;
		case PRE_SH5: fprintf(args.output, ".NH 5\n%s\n.PP", strip_whitespace(&text[6])); break;
		case PRE_IP:  fprintf(args.output, ".IP -"); break;
		default: fprintf(stderr, "Warning: Unimplemented syntax at line %d\n", yylineno);
	}
	printf("\n");
}

/* 
 * Process stuff that surrounds the line in Markdown (**bold**, *italic*, etc).
 */
void do_surround(char *text, int type)
{
	switch (type) {
		case SUR_BI: fprintf(args.output, ".B\n.I\n%s\n.R", strip_surround(text, 3)); break;
		case SUR_B: fprintf(args.output, "\n.B \"%s\"", strip_surround(text, 2)); break;
		case SUR_I: fprintf(args.output, "\n.I \"%s\"\n", strip_surround(text, 1)); break;
		case SUR_UL: fprintf(args.output, "\n.UL \"%s\"", strip_surround(text, 2)); break;
		case SUR_M: fprintf(args.output, "\n.ft 8\n%s\n.R", strip_surround(text, 1)); break;
		default: fprintf(stderr, "Warning: Unimplemented\n");
	}
	printf("\n");
}

FILE *open_file(const char *path, const char *flags) {
	FILE *f = fopen(path, flags);
	if (!f) {
		fprintf(stderr, "Error: Can't open file at path %s\n", path);
		exit(EXIT_FAILURE);
	}
	return f;
}

void parse_args(int argc, char *argv[]) {
	int opt;
	while ((opt = getopt(argc, argv, "bnopt:a:")) != -1) {
		switch (opt) {
			case 'b':
				args.flags |= FLAG_BREAK_FRONT_PAGE;
				break;
			case 'n':
				args.flags |= FLAG_NO_DATE_DISPLAY;
				break;
			case 'o':
				args.output_path = optarg;
				break;
			case 'p':
				args.flags |= FLAG_CONVERT_TO_PDF;
				break;
			case 't':
				args.title = optarg;
				break;
			case 'a':
				args.author = optarg;
				break;
			default:
				usage();
		}
	}

	if (optind < argc) {
		args.input = open_file(argv[optind], "r");
	} else {
		args.input = stdin;
	}
}

void print_head()
{
	fprintf(args.output, ".fp 8 CW\n");
	if (args.flags & FLAG_BREAK_FRONT_PAGE) {
		fprintf(args.output, ".RP no\n");
	}
	if (args.flags & FLAG_NO_DATE_DISPLAY) {
		fprintf(args.output, ".ND \"\"\n");
	}
	if (args.title) {
		fprintf(args.output, ".TL \n%s\n", args.title);
	}
	if (args.author) {
		fprintf(args.output, ".AU\n%s\n", args.title);
	}

}

/*
 * Strip whitespace (spaces and tabs) off a line.
 */
char *strip_whitespace(char *str)
{
	int i;
	for (i = 0; i < strlen(str); i++) {
		if (str[i] != ' ' && str[i] != '\t')
			return &str[i];
	}
	return NULL;
}

/* 
 * Strip surrounding chars from a given length ("_example*" with len 1
 * becomes "example").
 */
char *strip_surround(char *str, int len)
{
	str[strlen(str) - len] = '\0';
	return strip_whitespace(&str[len]);
}

/*
 * Print program usage and quit with an error status.
 */
void usage(void)
{
	fprintf(stderr, "usage: md2roff [-bnp] [-t title] [-a author] [-o output] [file]\n");
	exit(EXIT_FAILURE);
}

int main(int argc, char *argv[])
{
	FILE *pipe = NULL;
	parse_args(argc, argv);

	if (args.flags & FLAG_CONVERT_TO_PDF) {
		const char *command = "groff -ms -Tpdf";
		if (args.output_path) {
			char commandstr[64];
			sprintf(commandstr, "%s -o %s", command, args.output_path); // TODO could be segfault here
			pipe = popen(commandstr, "w");
		} else {
			pipe = popen(command, "w");
		}
		yyout = pipe;
	} else if (args.output_path) {
		args.output = open_file(args.output_path, "rw");
	}

	yyin = args.input;
	yyout = args.output;
	print_head();
	yylex();

	if (args.input != stdin) {
		fclose(args.input);
	}
	if (args.output != stdout) {
		fclose(args.output);
	}
	if (pipe) {
		pclose(pipe);
	}
	return 0;
}