%{
#include <stdio.h>
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
STRING [a-zA-Z0-9!@#$%^&(),. \t]

%%
"# "{STRING}+"\n" do_pre(yytext, PRE_SH1);
"## "{STRING}+"\n" do_pre(yytext, PRE_SH2);
"### "{STRING}+"\n" do_pre(yytext, PRE_SH3);
"#### "{STRING}+"\n" do_pre(yytext, PRE_SH4);
"##### "{STRING}+"\n" do_pre(yytext, PRE_SH5);
"* "{STRING}+"\n" do_pre(yytext, PRE_IP);
"***"{STRING}+"***" do_surround(yytext, SUR_BI);
"**"{STRING}+"**" do_surround(yytext, SUR_B);
"*"{STRING}+"*" do_surround(yytext, SUR_I);
"__"{STRING}+"__" do_surround(yytext, SUR_UL);
"`"{STRING}+"`" do_surround(yytext, SUR_M);
%%

void do_pre(char *text, int type)
{
	switch (type) {
		case PRE_SH1: printf(".TL\n%s\n.PP", strip_whitespace(&text[2])); break;
		case PRE_SH2: printf(".SH\n%s\n.PP", strip_whitespace(&text[3])); break;
		case PRE_SH3: printf(".SH\n%s\n.PP", strip_whitespace(&text[4])); break;
		case PRE_SH4: printf(".SH\n%s\n.PP", strip_whitespace(&text[5])); break;
		case PRE_SH5: printf(".SH\n%s\n.PP", strip_whitespace(&text[6])); break;
		case PRE_IP:  printf(".IP -\n%s\n.PP", strip_whitespace(&text[2])); break;
		default: fprintf(stderr, "error: unimplemented\n");
	}
	printf("\n");
}

void do_surround(char *text, int type)
{
	switch (type) {
		case SUR_BI: printf(".B\n.I\n%s\n.R", strip_surround(text, 3)); break;
		case SUR_B: printf("\n.B \"%s\"", strip_surround(text, 2)); break;
		case SUR_I: printf("\n.I \"%s\"", strip_surround(text, 1)); break;
		case SUR_UL: printf("\n.UL \"%s\"", strip_surround(text, 2)); break;
		case SUR_M: printf("\n.M \"%s\"", strip_surround(text, 1)); break;
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
