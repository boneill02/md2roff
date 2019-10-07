%{
#include <stdio.h>
char *strip_whitespace(char *str);
char *strip_surround(char *str, int len);
%}

%option noyywrap

STRING [a-zA-Z0-9?!.,]*
WHITESPACE [ \t]

%%
"# " printf(".TL\n%s", &yytext[2]);
"## " printf(".SH 2\n%s", &yytext[3]);
"### " printf(".SH 3\n%s", &yytext[4]);
"#### " printf(".SH 4\n%s", &yytext[5]);
"##### " printf(".SH 5\n%s", &yytext[6]);
"* " printf(".IP -\n%s", &yytext[2]);
"***"{STRING}"***" printf("\n.BI %s", strip_surround(yytext, 3));
"**"{STRING}"**" printf("\n.B %s", strip_surround(yytext, 2));
"*"{STRING}"*" printf("\n.I %s", strip_surround(yytext, 1));
"__"{STRING}"__" printf("\n.UL %s", strip_surround(yytext, 2));
"\n\n" printf("\n.PP\n");
%%

char *
strip_whitespace(char *str)
{
	int i;
	for (i = 0; i < strlen(str); i++) {
		if (str[i] != ' ' && str[i] != '\t')
			return &str[i];
	}
	return "";
}

char *
strip_surround(char *str, int len)
{
	str[strlen(str) - len] = '\0';
	return strip_whitespace(&str[len]);
}
