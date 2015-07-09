{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}
{-# LANGUAGE TypeFamilies       #-}

-- Module      : Network.AWS.AutoScaling.DescribePolicies
-- Copyright   : (c) 2013-2015 Brendan Hay
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- | Describes the policies for the specified Auto Scaling group.
--
-- <http://docs.aws.amazon.com/AutoScaling/latest/APIReference/API_DescribePolicies.html>
module Network.AWS.AutoScaling.DescribePolicies
    (
    -- * Request
      DescribePolicies
    -- ** Request constructor
    , describePolicies
    -- ** Request lenses
    , descPolicyNames
    , descNextToken
    , descMaxRecords
    , descAutoScalingGroupName
    , descPolicyTypes

    -- * Response
    , DescribePoliciesResponse
    -- ** Response constructor
    , describePoliciesResponse
    -- ** Response lenses
    , dprNextToken
    , dprScalingPolicies
    , dprStatus
    ) where

import           Network.AWS.AutoScaling.Types
import           Network.AWS.Pager
import           Network.AWS.Prelude
import           Network.AWS.Request
import           Network.AWS.Response

-- | /See:/ 'describePolicies' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'descPolicyNames'
--
-- * 'descNextToken'
--
-- * 'descMaxRecords'
--
-- * 'descAutoScalingGroupName'
--
-- * 'descPolicyTypes'
data DescribePolicies = DescribePolicies'
    { _descPolicyNames          :: !(Maybe [Text])
    , _descNextToken            :: !(Maybe Text)
    , _descMaxRecords           :: !(Maybe Int)
    , _descAutoScalingGroupName :: !(Maybe Text)
    , _descPolicyTypes          :: !(Maybe [Text])
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'DescribePolicies' smart constructor.
describePolicies :: DescribePolicies
describePolicies =
    DescribePolicies'
    { _descPolicyNames = Nothing
    , _descNextToken = Nothing
    , _descMaxRecords = Nothing
    , _descAutoScalingGroupName = Nothing
    , _descPolicyTypes = Nothing
    }

-- | One or more policy names or policy ARNs to be described. If you omit
-- this list, all policy names are described. If an group name is provided,
-- the results are limited to that group. This list is limited to 50 items.
-- If you specify an unknown policy name, it is ignored with no error.
descPolicyNames :: Lens' DescribePolicies [Text]
descPolicyNames = lens _descPolicyNames (\ s a -> s{_descPolicyNames = a}) . _Default;

-- | The token for the next set of items to return. (You received this token
-- from a previous call.)
descNextToken :: Lens' DescribePolicies (Maybe Text)
descNextToken = lens _descNextToken (\ s a -> s{_descNextToken = a});

-- | The maximum number of items to be returned with each call.
descMaxRecords :: Lens' DescribePolicies (Maybe Int)
descMaxRecords = lens _descMaxRecords (\ s a -> s{_descMaxRecords = a});

-- | The name of the group.
descAutoScalingGroupName :: Lens' DescribePolicies (Maybe Text)
descAutoScalingGroupName = lens _descAutoScalingGroupName (\ s a -> s{_descAutoScalingGroupName = a});

-- | One or more policy types. Valid values are @SimpleScaling@ and
-- @StepScaling@.
descPolicyTypes :: Lens' DescribePolicies [Text]
descPolicyTypes = lens _descPolicyTypes (\ s a -> s{_descPolicyTypes = a}) . _Default;

instance AWSPager DescribePolicies where
        page rq rs
          | stop (rs ^. dprNextToken) = Nothing
          | stop (rs ^. dprScalingPolicies) = Nothing
          | otherwise =
            Just $ rq & descNextToken .~ rs ^. dprNextToken

instance AWSRequest DescribePolicies where
        type Sv DescribePolicies = AutoScaling
        type Rs DescribePolicies = DescribePoliciesResponse
        request = post
        response
          = receiveXMLWrapper "DescribePoliciesResult"
              (\ s h x ->
                 DescribePoliciesResponse' <$>
                   (x .@? "NextToken") <*>
                     (x .@? "ScalingPolicies" .!@ mempty >>=
                        may (parseXMLList "member"))
                     <*> (pure (fromEnum s)))

instance ToHeaders DescribePolicies where
        toHeaders = const mempty

instance ToPath DescribePolicies where
        toPath = const "/"

instance ToQuery DescribePolicies where
        toQuery DescribePolicies'{..}
          = mconcat
              ["Action" =: ("DescribePolicies" :: ByteString),
               "Version" =: ("2011-01-01" :: ByteString),
               "PolicyNames" =:
                 toQuery (toQueryList "member" <$> _descPolicyNames),
               "NextToken" =: _descNextToken,
               "MaxRecords" =: _descMaxRecords,
               "AutoScalingGroupName" =: _descAutoScalingGroupName,
               "PolicyTypes" =:
                 toQuery (toQueryList "member" <$> _descPolicyTypes)]

-- | /See:/ 'describePoliciesResponse' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dprNextToken'
--
-- * 'dprScalingPolicies'
--
-- * 'dprStatus'
data DescribePoliciesResponse = DescribePoliciesResponse'
    { _dprNextToken       :: !(Maybe Text)
    , _dprScalingPolicies :: !(Maybe [ScalingPolicy])
    , _dprStatus          :: !Int
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'DescribePoliciesResponse' smart constructor.
describePoliciesResponse :: Int -> DescribePoliciesResponse
describePoliciesResponse pStatus =
    DescribePoliciesResponse'
    { _dprNextToken = Nothing
    , _dprScalingPolicies = Nothing
    , _dprStatus = pStatus
    }

-- | The token to use when requesting the next set of items. If there are no
-- additional items to return, the string is empty.
dprNextToken :: Lens' DescribePoliciesResponse (Maybe Text)
dprNextToken = lens _dprNextToken (\ s a -> s{_dprNextToken = a});

-- | The scaling policies.
dprScalingPolicies :: Lens' DescribePoliciesResponse [ScalingPolicy]
dprScalingPolicies = lens _dprScalingPolicies (\ s a -> s{_dprScalingPolicies = a}) . _Default;

-- | FIXME: Undocumented member.
dprStatus :: Lens' DescribePoliciesResponse Int
dprStatus = lens _dprStatus (\ s a -> s{_dprStatus = a});
