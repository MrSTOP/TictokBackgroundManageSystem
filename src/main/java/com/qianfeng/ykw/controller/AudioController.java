package com.qianfeng.ykw.controller;

import com.qianfeng.ykw.UserRoleType;
import com.qianfeng.ykw.pojo.*;
import com.qianfeng.ykw.dao.IAudioDAO;
import com.qianfeng.ykw.pojo.Audio;
import com.qianfeng.ykw.service.IAudioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/AudioController")
public class AudioController {
    @Autowired
    IAudioService audioService;

    /**
     * 上传音频文件
     * @param audio
     * @param multipartFile
     * @param request
     * @return
     */
    @RequestMapping("/uploadAudio")
    public String uploadAudio(Audio audio, MultipartFile multipartFile, HttpServletRequest request) {
        boolean result = false;
        try {
            result = audioService.upload(audio, multipartFile, request);
        } catch (IOException e) {
            e.printStackTrace();
        }
        if (result) {
            request.setAttribute("msg","上传成功");
            return "/pages/audio/add_audio";
        } else {
            request.setAttribute("msg","上传失败");
            return null;
        }
    }

    /**
     * 查询当前商户所有音频
     * @param request
     * @return
     */
    @RequestMapping("/queryAudio")
    public String queryAudio(HttpServletRequest request) {
        int businessId = ((Business) request.getSession().getAttribute("business")).getBusinessId();
        List<Audio> audioList = audioService.selectAudioInfoByBusinessId(businessId);
        request.setAttribute("audioList", audioList);
        return "/pages/audio/query_audio";
    }

    /**
     * 查询所有商户所有音频
     * @param request
     * @return
     */
    @RequestMapping("/queryAllAudio")
    public String queryAllAudio(HttpServletRequest request) {
        List<Audio> audioList = audioService.selectAllAudio();
        request.setAttribute("audioList", audioList);
        return "/pages/audio/query_audio";
    }

    /**
     * 根据获取用户businessId查询对应音频
     * @param businessId
     * @param request
     * @return
     */
    @RequestMapping("/queryAudioById")
    public String queryAudioById(int businessId,HttpServletRequest request) {
        List<Audio> audioList = audioService.selectAudioInfoByBusinessId(businessId);
        request.setAttribute("audioList", audioList);
        return "/pages/audio/query_audio";
    }
    
    
    /**
     * 将Id对应的音频移入回收站
     * @param audioId
     * @param request
     * @return
     */
    @RequestMapping("/deleteAudio")
    @ResponseBody
    public Map<String, Object> deleteAudio(int audioId, HttpServletRequest request) {
        Map<String, Object> param = new HashMap<>();
        Map<String, Object> result = new HashMap<>();
        UserRoleType userRoleType = (UserRoleType) request.getSession().getAttribute("UserRoleType");
        param.put("audioId", audioId);
        if (userRoleType == UserRoleType.ROLE_BUSINESS) {
            param.put("deleteType", DeleteAudio.DELETE_BY_BUSINESS);
            param.put("uid", null);
        } else if (userRoleType == UserRoleType.ROLE_ADMINISTRATOR) {
            SystemUser systemUser = (SystemUser) request.getSession().getAttribute("systemUser");
            param.put("deleteType", DeleteAudio.DELETE_BY_ADMINISTRATOR);
            param.put("uid", systemUser.getUid());
        }
        try {
            audioService.moveAudioToRecycleBinProcByIdAndType(param);
            result.put("result", true);
        } catch (DataAccessException e) {
            e.printStackTrace();
            result.put("result", false);
        }
        return result;
    }
    
    /**
     * 获取回收站中所有音频
     * @param request
     * @return
     */
    @RequestMapping("/queryAllRecycleBinAudio")
    public String queryAllRecycleBinAudio(HttpServletRequest request) {
        List<DeleteAudio> recycleBinAudioList = audioService.selectAllRecycleBinAudio(request);
        request.setAttribute("recycleBinAudioList", recycleBinAudioList);
        return "/pages/audio/audio_recycle_bin";
    }
    
    /**
     * 获取回收站中对应businessId的所有音频
     * @param businessId
     * @param request
     * @return
     */
    @RequestMapping("/queryRecycleBinAudioByBusinessId")
    public String queryRecycleBinAudioByBusinessId(int businessId, HttpServletRequest request) {
        List<DeleteAudio> recycleBinAudioList = audioService.selectRecycleBinAudioByBusinessId(businessId, request);
        request.setAttribute("recycleBinAudioList", recycleBinAudioList);
        return "/pages/audio/audio_recycle_bin";
    }
    
    /**
     * 根据用户登录身份确定查询音频的范围
     * @param request
     * @return
     */
    @RequestMapping("/queryRecycleBinAudio")
    public String queryRecycleBinAudio(HttpServletRequest request) {
        UserRoleType userRoleType = (UserRoleType) request.getSession().getAttribute("UserRoleType");
        if (userRoleType == UserRoleType.ROLE_ADMINISTRATOR) {
            return queryAllRecycleBinAudio(request);
        } else if (userRoleType == UserRoleType.ROLE_BUSINESS) {
            int businessId = ((Business) request.getSession().getAttribute("business")).getBusinessId();
            return queryRecycleBinAudioByBusinessId(businessId, request);
        }
        return null;
    }
    
    /**
     * 将回收站中对应Id的音频还原
     * @param audioId
     * @return
     */
    @RequestMapping("/recoverAudio")
    @ResponseBody
    public Map<String, Object> recoverAudio(int audioId) {
        Map<String, Object> result = new HashMap<>();
        if (audioService.recoverAudioFromRecycleBinProcById(audioId)) {
            result.put("result", true);
        } else {
            result.put("result", false);
        }
        return result;
    }
    
    /**
     * 将回收站中对应Id的音频彻底删除
     * @param audioId
     * @param request
     * @return
     */
    @RequestMapping("/deleteAudioPermanently")
    @ResponseBody
    public Map<String, Object> deleteAudioPermanently(int audioId, HttpServletRequest request) {
        //TODO
        Map<String, Object> result = new HashMap<>();
        try {
            if (audioService.deleteAudioPermanently(audioId, request)) {
                result.put("result", true);
            } else {
                result.put("result", false);
            }
        } catch (IllegalStateException e) {
            e.printStackTrace();
            result.put("result", false);
        }
        return result;
    }
    
    
    @RequestMapping("/queryAudioByOther")
    public String queryAudioByOther(String selectbusiness_name, String startdate, String enddate, HttpServletRequest request){
        Map<String,Object> map = new HashMap<String, Object>();

        if(selectbusiness_name == null ||selectbusiness_name.isEmpty()){
            if(startdate == null||enddate == null ||startdate.isEmpty()||enddate.isEmpty()){
                map.put("selectType","0");
            }else{
                map.put("selectType","2");
            }
        }else{
            if(startdate == null||enddate == null||startdate.isEmpty()||enddate.isEmpty()){
                map.put("selectType","1");
            }else{
                map.put("selectType","3");
            }
        }
        map.put("business_name",selectbusiness_name);
        map.put("startdate",startdate);
        map.put("enddate",enddate);
        List<Audio> audioList = audioService.selectAudioByDateAndName(map);
        request.setAttribute("audioList",audioList);
        return "pages/audio/select_audio";

    }

}
