package org.bucketmap.home;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
  * HomeController
  *
  * @author sunghyun
  * @since 2016. 10. 22.
  */
@Controller
public class HomeController {
	@RequestMapping("/")
	public String index(){
		return "index";
	}

	@RequestMapping("/simple")
	public String indexSimple(){
		return "simple";
	}
}
