/***************************************************************************
 * css.c
 * Character-based parser for Css definitions
 * Author - Iago Rubio <iagorubio(at)users.sourceforge.net>
 **************************************************************************/
#include "general.h"

#include <string.h> 
#include <ctype.h> 

#include "parse.h" 
#include "read.h" 


typedef enum eCssKinds {
    K_NONE = -1, K_CLASS, K_SELECTOR, K_ID
} cssKind;

static kindOption CssKinds [] = {
    { TRUE, 'c', "class", "classes" },
    { TRUE, 's', "selector",  "selectors"  },
    { TRUE, 'i', "id",  "identities"  }
};

typedef enum _CssParserState {  // state of parsing
  P_STATE_NONE,         // default state
  P_STATE_IN_COMMENT,     // into a comment, only multi line in CSS
  P_STATE_IN_SINGLE_STRING, // into a single quoted string
  P_STATE_IN_DOUBLE_STRING, // into a double quoted string
  P_STATE_IN_DEFINITION,    // on the body of the style definition, nothing for us
  P_STATE_IN_MEDIA,     // on a @media declaration, can be multi-line
  P_STATE_IN_IMPORT,      // on a @import declaration, can be multi-line
  P_STATE_IN_NAMESPACE,   // on a @namespace declaration  
  P_STATE_IN_PAGE,      // on a @page declaration
  P_STATE_IN_FONTFACE,    // on a @font-face declaration
  P_STATE_AT_END        // end of parsing
} CssParserState;

static void makeCssSimpleTag( vString *name, cssKind kind, boolean delete )
{
  if (kind == K_CLASS) {
    vStringStripTrailing(name);
  }
  vStringTerminate (name);
  makeSimpleTag (name, CssKinds, kind);
  vStringClear (name);
  if( delete )
    vStringDelete (name);
}

static boolean isCssDeclarationAllowedChar( const unsigned char *cp )
{
  return  isalnum ((int) *cp) ||
      isspace ((int) *cp) ||
      *cp == '_' || // allowed char
      *cp == '-' || // allowed char     
      *cp == '+' ||   // allow all sibling in a single tag
      *cp == '>' ||   // allow all child in a single tag 
      *cp == '{' ||   // allow the start of the declaration
      *cp == '.' ||   // allow classes and selectors
      *cp == ',' ||   // allow multiple declarations
      *cp == ':' ||   // allow pseudo classes
      *cp == '*' ||   // allow globs as P + *
      *cp == '#';   // allow ids 
}

static CssParserState parseCssDeclaration( const unsigned char **position, cssKind kind )
{
  vString *name = vStringNew ();
  const unsigned char *cp = *position;

  // pick to the end of line including children and sibling
  // if declaration is multiline go for the next line 
  while ( isCssDeclarationAllowedChar(cp) || 
      *cp == '\0' )   // track the end of line into the loop
  {
    if( (int) *cp == '\0' )
    { 
      cp = fileReadLine ();
      if( cp == NULL ){
        makeCssSimpleTag(name, kind, TRUE);
        *position = cp;
        return P_STATE_AT_END;
      }
    }
    else if( *cp == ',' )
    {
      makeCssSimpleTag(name, kind, TRUE);
      *position = ++cp;
      return P_STATE_NONE;
    }
    else if( *cp == '{' )
    {
      makeCssSimpleTag(name, kind, TRUE);
      *position = ++cp;
      return P_STATE_IN_DEFINITION;
    }

    vStringPut (name, (int) *cp);
    ++cp;
  }
  
  makeCssSimpleTag(name, kind, TRUE);
  *position = cp;

  return P_STATE_NONE;
}

static CssParserState parseCssLine( const unsigned char *line, CssParserState state )
{
  vString *aux;

  while( *line != '\0' ) // fileReadLine returns NULL terminated strings
  {
    while (isspace ((int) *line))
      ++line;
    switch( state )
    {
      case P_STATE_NONE:
        // pick first char if alphanumeric is a selector
        if( isalnum ((int) *line) )
          state = parseCssDeclaration( &line, K_SELECTOR );
        else if( *line == '.' ) // a class
          state = parseCssDeclaration( &line, K_CLASS );
        else if( *line == '#' ) // an id
          state = parseCssDeclaration( &line, K_ID );
        else if( *line == '@' ) // at-rules, we'll ignore them
        {
          ++line;
          aux = vStringNew();
          while( !isspace((int) *line) )
          {
            vStringPut (aux, (int) *line);
            ++line;         
          }
          vStringTerminate (aux);
          if( strcmp( aux->buffer, "media" ) == 0 )
            state = P_STATE_IN_MEDIA;
          else if ( strcmp( aux->buffer, "import" ) == 0 )
            state = P_STATE_IN_IMPORT;
          else if ( strcmp( aux->buffer, "namespace" ) == 0 )
            state = P_STATE_IN_NAMESPACE; 
          else if ( strcmp( aux->buffer, "page" ) == 0 )
            state = P_STATE_IN_PAGE;
          else if ( strcmp( aux->buffer, "font-face" ) == 0 )
            state = P_STATE_IN_FONTFACE;
          vStringDelete (aux);
        }
        else if( *line == '*' && *(line-1) == '/' ) // multi-line comment
          state = P_STATE_IN_COMMENT;
      break;
      case P_STATE_IN_COMMENT:
        if( *line == '/' && *(line-1) == '*')
          state = P_STATE_NONE;
      break;
      case  P_STATE_IN_SINGLE_STRING: 
        if( *line == '\'' && *(line-1) != '\\' )
          state = P_STATE_IN_DEFINITION; // PAGE, FONTFACE and DEFINITION are treated the same way
      break;
      case  P_STATE_IN_DOUBLE_STRING:
        if( *line=='"' && *(line-1) != '\\' )
          state = P_STATE_IN_DEFINITION; // PAGE, FONTFACE and DEFINITION are treated the same way
      break;
      case  P_STATE_IN_MEDIA:
        // skip to start of media body or line end
        while( *line != '{' )
        {
          if( *line == '\0' )
            break;
          ++line;
        }
        if( *line == '{' )
            state = P_STATE_NONE;
      break;
      case  P_STATE_IN_IMPORT:
      case  P_STATE_IN_NAMESPACE:
        // skip to end of declaration or line end
        while( *line != ';' )
        {
          if( *line == '\0' )
            break;
          ++line;
        }
        if( *line == ';' )
          state = P_STATE_NONE;
      break;
      case P_STATE_IN_PAGE:
      case P_STATE_IN_FONTFACE:
      case P_STATE_IN_DEFINITION:
        if( *line == '}' )
          state = P_STATE_NONE;
        else if( *line == '\'' )
          state = P_STATE_IN_SINGLE_STRING;
        else if( *line == '"' )
          state = P_STATE_IN_DOUBLE_STRING;
      break;
      case P_STATE_AT_END:
        return state;
      break;
    }   
    if (line == NULL)
	break;
    line++;
  }
  return state;
}

static void findCssTags (void)
{
    const unsigned char *line;
  CssParserState state = P_STATE_NONE;

    while ( (line = fileReadLine ()) != NULL )
    {
    state = parseCssLine( line, state );
    if( state==P_STATE_AT_END ) return;
    }    
}

/* parser definition */
extern parserDefinition* CssParser (void)
{
    static const char *const extensions [] = { "css", NULL };
    parserDefinition* def = parserNew ("CSS");
    def->kinds      = CssKinds;
    def->kindCount  = KIND_COUNT (CssKinds);
    def->extensions = extensions;
    def->parser     = findCssTags;
    return def;
}

