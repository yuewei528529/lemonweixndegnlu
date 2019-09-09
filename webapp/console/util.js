
//�ж�һ���ַ����Ƿ�Ϊ�ջ�null������ֻ�����ո�
function isEmpty( str ) {
	if ( str == null ) return true;
	if ( trim( str ) == "" ) return true;
	return false;
}

//ɾ��һ���ַ�����β�Ŀո�
function trim( strInput ) {
	var iLoop = 0;
	var iLoop2 = -1;
	var strChr;
	
	if( ( strInput == null) || ( strInput == "" ) )	return "";
	if( strInput )	{
		for( iLoop = 0; iLoop < strInput.length; iLoop++ ) {
			strChr = strInput.charAt( iLoop );
			if( strChr != ' ' )
			break;
		}
		for( iLoop2 = strInput.length - 1; iLoop2 >= 0; iLoop2-- ) {
			strChr = strInput.charAt( iLoop2 );
			if( strChr != ' ' )
			break;
		}
	}
	
	if( iLoop <= iLoop2 )	{
		return strInput.substring( iLoop, iLoop2 + 1 );
	}
	else 	return "";
}

//Ϊһ�������б����ĩβ���һ����ѡ��
//svalue ѡ���ֵ  sdisp ѡ�����ʾ����
function addSelectItem( selectObj, svalue, sdisp ) {
	var newItem = new Option( sdisp, svalue, false, false );
	var index = selectObj.length;
	selectObj.options[ index ] = newItem;
}

//���SELECTԪ��������ѡ����Ŀ��valueֵ���Զ��ŷָ�
function getSelectedValues( selectObj ) {
	if( selectObj.tagName != "SELECT" ) return "";
	var s = "";
	for( var i = 0; i < selectObj.length; i++ ) {
		var obj = selectObj.item( i );
		if( obj.selected ) s += "," + obj.value;
	}
	if( s.length > 0 ) s = s.substring( 1 );
	return s;
}

function urlEncode( str )
{
	var dst = "";
	for ( var i = 0; i < str.length; i++ )
	{
		switch ( str.charAt( i ) )
		{
			case ' ':
				dst += "+";
				break;
			case '!':
				dst += "%21";
				break;
			case '\"':
				dst += "%22";
				break;
			case '#':
				dst += "%23";
				break;
			case '$':
				dst += "%24";
				break;
			case '%':
				dst += "%25";
				break;
			case '&':
				dst += "%26";
				break;
			case '\'':
				dst += "%27";
				break;
			case '(':
				dst += "%28";
				break;
			case ')':
				dst += "%29";
				break;
			case '+':
				dst += "%2B";
				break;
			case ',':
				dst += "%2C";
				break;
			case '/':
				dst += "%2F";
				break;
			case ':':
				dst += "%3A";
				break;
			case ';':
				dst += "%3B";
				break;
			case '<':
				dst += "%3C";
				break;
			case '=':
				dst += "%3D";
				break;
			case '>':
				dst += "%3E";
				break;
			case '?':
				dst += "%3F";
				break;
			case '@':
				dst += "%40";
				break;
			case '[':
				dst += "%5B";
				break;
			case '\\':
				dst += "%5C";
				break;
			case ']':
				dst += "%5D";
				break;
			case '^':
				dst += "%5E";
				break;
			case '`':
				dst += "%60";
				break;
			case '{':
				dst += "%7B";
				break;
			case '|':
				dst += "%7C";
				break;
			case '}':
				dst += "%7D";
				break;
			case '~':
				dst += "%7E";
				break;
			default:
				dst += str.charAt( i );
				break;
		}
	}
	return dst;
}

