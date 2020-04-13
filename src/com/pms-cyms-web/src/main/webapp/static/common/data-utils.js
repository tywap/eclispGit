// create by gaoyiping
// 2018-04-10

// 空值判断
function isNullVal(value) {
	if (typeof(value) == undefined) return true;
	if (value == null) return true;
	if (value.length == 0) return true;
	if (value.trim().length == 0) return true;
	return false;
}

// 简易的Datetime取值判断(e: 2018-04-10 17:10)
function isInvalidDatetime(value) {
	if (isNullVal(value)) return true;
	if (value.indexOf("－") >= 0) {
		var reg = new RegExp("－","g");
		value = value.replace(reg,"-");   
	}
	if (value.indexOf("：") >= 0) {
		var reg = new RegExp("：","g");
		value = value.replace(reg,":");
	}
	var dt = value.split(' ');
	if (dt.length == 2) {
		dl = dt[0].split('-');
		if (dl.length == 3) {
			if (isNaN(dl[0]) || isNaN(dl[1]) || isNaN(dl[2])) return true;
		} else {
			return true;
		}
		tl = dt[1].split(':');
		if (tl.length == 2) {
			if (isNaN(tl[0]) || isNaN(tl[1])) return true;
		} else {
			return true;
		}
		return false;
	}
	return true;
}

// 简易的Date取值判断(e: 2018-04-10)
function isInvalidDate(value) {
	if (isNullVal(value)) return true;
	if (value.indexOf("－") >= 0) {
		var reg = new RegExp("－","g");
		value = value.replace(reg,"-");   
	}
	dl = value.split('-');
	if (dl.length == 3) {
		if (isNaN(dl[0]) || isNaN(dl[1]) || isNaN(dl[2])) return true;
	} else {
		return true;
	}
	return false;
}