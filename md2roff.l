%{
#include <stdio.h>
#include <string.h>
void do_pre(char *text, int type);
void do_surround(char *text, int type);

char *strip_surround(char *str, int len);
char *strip_whitespace(char *str);

enum {
	PRE_TL,
	PRE_SH1,
	PRE_SH2,
	PRE_SH3,
	PRE_SH4,
	PRE_SH5,
	PRE_IP,
};

enum {
	SUR_BI,
	SUR_B,
	SUR_I,
	SUR_UL,
	SUR_M,
};
%}

%option noyywrap
%option no
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

int main(int argc, char *argv[])
{
	char *file;


	++argv, --argc;
	if (argc > 0) {
		for (int i = 0; i < argc; i++) {
			if (*argv[i] == '-' && strlen(argv[i]) > 1) {
				for (int j = 1; j < strlen(argv[i]); j++) {
					switch (argv[i][j]) {
						case 't': /* set title */
							printf(".TL\n%s\n", argv[++i]);
							break;
						case 'a': /* set author */
							printf(".AU\n%s\n", argv[++i]);
							break;
						case 'b': /* break front page */
							printf(".RP no\n");
							break;
						case 'n': /* no date display */
							printf(".ND \"\"\n");
							break;
						default:
							fprintf(stderr, "usage: md2roff [-bn] [-t title] [-a author] [file...]\n");
							exit(EXIT_FAILURE);
					}
				}
			} else {
				file = argv[i];
			}
		}
		printf(".fp 8 C\n");
		yyin = fopen(file, "r");
		yylex();
	} else {
		printf(".fp 8 C\n");
		yyin = fopen(file, "r");
		yyin = stdin;
		yylex();
	}
	return 0;
}

void do_pre(char *text, int type)
{
	switch (type) {
		case PRE_SH1: printf(".NH 1\n%s\n.PP", strip_whitespace(&text[2])); break;
		case PRE_SH2: printf(".NH 2\n%s\n.PP", strip_whitespace(&text[3])); break;
		case PRE_SH3: printf(".NH 3\n%s\n.PP", strip_whitespace(&text[4])); break;
		case PRE_SH4: printf(".NH 4\n%s\n.PP", strip_whitespace(&text[5])); break;
		case PRE_SH5: printf(".NH 5\n%s\n.PP", strip_whitespace(&text[6])); break;
		case PRE_IP:  printf(".IP -"); break;
		default: fprintf(stderr, "error: unimplemented\n");
	}
	printf("\n");
}

void do_surround(char *text, int type)
{
	switch (type) {
		case SUR_BI: printf(".B\n.I\n%s\n.R", strip_surround(text, 3)); break;
		case SUR_B: printf("\n.B \"%s\"", strip_surround(text, 2)); break;
		case SUR_I: printf("\n.I \"%s\"\n", strip_surround(text, 1)); break;
		case SUR_UL: printf("\n.UL \"%s\"", strip_surround(text, 2)); break;
		case SUR_M: printf("\n.ft 8\n%s\n.R", strip_surround(text, 1)); break;
		default: fprintf(stderr, "error: unimplemented\n");
	}
	printf("\n");
}

char *strip_whitespace(char *str)
{
	int i;
	for (i = 0; i < strlen(str); i++) {
		if (str[i] != ' ' && str[i] != '\t')
			return &str[i];
	}
	return "";
}

char *strip_surround(char *str, int len)
{
	str[strlen(str) - len] = '\0';
	return strip_whitespace(&str[len]);
}
